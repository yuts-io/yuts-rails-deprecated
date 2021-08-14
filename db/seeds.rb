
# THIS SEEDER ASSUMES THERE IS A FILE OF SEASON JSON FILES FROM COURSETABLE IN A FILE CALLED 
# ct-data WITH EACH JSON FILE CONTAINING ONE SEM OF CLASSES
# IF A YALE STUDENT, THIS DATA CAN BE CURRENTLY BE COLLECTED AT https://api.coursetable.com/api/static/catalogs/{SEASON_CODE}.json

# season code format = YEAR + 01 for SPRING or 02 for SUMMER or 03 for FALL

def get_percentile(objs, sorter_category, new_category)

    sorted_objs = objs.sort_by { |course| course[sorter_category]}
    count = objs.count

    sorted_objs.each_with_index do |course, i|
        # L/N(100) = P
        # L = number of scores beneath this score (score array index)
        # N = total number of scores
        # P = percentile

        percentile = (i.to_f/count.to_f*100).ceil

        course_obj = Course.find_by(id: course.id)

        course_obj[new_category] = percentile

        course_obj.save
    end

end

def get_guts(course)
    if (course["average_rating"] == nil || course["average_workload"] == nil)
        course["gut_index"] = nil
    else 
        rating_work_ratio = course["average_rating"]/course["average_workload"]
    
        if rating_work_ratio > 1
            raw_score = (1 - ((2.5 - rating_work_ratio)/1.5)) * 50
    
            raw_score += 50 # balance scale to max of 100
        elsif rating_work_ratio < 1
            raw_score = (1 - ((1-rating_work_ratio)/0.8)) * 50
        else
            raw_score = 50.0
        end
    
    
        if raw_score > 100 
            course["gut_index"] = 100.0
        elsif raw_score < 0 
            course["gut_index"] = 0.0
        else
            course["gut_index"] = raw_score
        end
    end
end

def get_stats(courses, category, subject=false)

    courses_cat = courses.map {|course| course[category]}
    courses_cat.extend(DescriptiveStatistics)

    avg = courses_cat.mean
    median = courses_cat.median
    std_dev = courses_cat.standard_deviation
    mode = courses_cat.mode
    range = courses_cat.range

    if subject
        courses.each do |course|
            course[category + "_subject_mean"] = avg
            course[category + "_subject_median"] = median
            course[category + "_subject_standard_deviation"] = std_dev
            course[category + "_subject_mode"] = mode
            course[category + "_subject_range"] = range 
            course.save
        end
    else
        courses.each do |course|
            course[category + "_mean"] = avg
            course[category + "_median"] = median
            course[category + "_standard_deviation"] = std_dev
            course[category + "_mode"] = mode
            course[category + "_range"] = range 
            course.save
        end
    end

end


def clean_data(courses)

    records_w_guts = courses.each do |course|
        course.delete("times_by_day")
        course["all_course_codes"] = course["all_course_codes"].join(', ')
        course["areas"] = course["areas"].join(', ')
        
        course["flag_info"] = course["flag_info"].join(', ')
        course["professor_names"] = course["professor_names"].join(', ')
        course["skills"] = course["skills"].join(', ')
        
        get_guts(course)
        Course.create(course)
    end
    
end

## DATA PROCESSING


total_counter = 1
total_count = Dir.children("./db/ct-data").count


## ACTUAL ITERATION THRU ALL JSON FILES

Dir.children("./db/ct-data").each do |filename|
    ## OPEN FILE
    path = File.join(File.dirname(__FILE__), "/ct-data/#{filename}")
    courses_raw_data = JSON.parse(File.read(path))

    ## PREPARE DATA
    puts "starting file #{total_counter} / #{total_count}"

    clean_data(courses_raw_data)

    season_json_str = filename
    season_code_str = season_json_str[0...6].to_i
    courses_in_season = Course.all.select {|course| course.season_code == season_code_str}
    
    gut_objs = courses_in_season.select {|course| course.gut_index != nil }
    prof_objs = courses_in_season.select {|course| (course.average_professor != nil)}
    workload_objs = courses_in_season.select {|course| (course.average_workload != nil)}
    same_prof_tot_rating_objs = courses_in_season.select {|course| (course.average_rating_same_professors != nil)}
    same_prof_workload_objs = courses_in_season.select {|course| (course.average_workload_same_professors != nil)}
    
    ## GET STATS ON ALL DATA FOR SEASON
    puts "getting percentiles"
    
    get_percentile(gut_objs, "gut_index", "gut_percentile")
    get_percentile(prof_objs, "average_professor", "professor_percentile")
    get_percentile(workload_objs, "average_workload", "workload_percentile")
    get_percentile(same_prof_tot_rating_objs, "average_rating_same_professors", "same_professor_total_rating_percentile")
    get_percentile(same_prof_workload_objs, "average_workload_same_professors", "same_professor_workload_percentile")
    
    ## GET STATS ON ALL DATA FOR SEASON
    puts "getting stats"
    
    get_stats(gut_objs, "gut_index")
    get_stats(prof_objs, "average_professor")
    get_stats(prof_objs, "average_workload")
    get_stats(prof_objs, "average_rating_same_professors")
    get_stats(prof_objs, "average_workload_same_professors")
    
    
    ## GET SUBJECT PERCENTILES AND SUBJECT STATS FOR SEASON
    
    puts "getting subject percentiles"

    subjects = courses_in_season.map {|course| course.subject}.uniq
    
    subjects.each do |subject|
    
        courses_in_subject = courses_in_season.select {|course| course.subject == subject }
    
        gut_courses_in_subject = courses_in_subject.select {|course| course.gut_index != nil}
        get_percentile(gut_courses_in_subject, "gut_index", "gut_percentile_subject")
        get_stats(gut_courses_in_subject, "gut_index", true)
    
        prof_courses_in_subject = courses_in_subject.select {|course| course.average_professor != nil}
        get_percentile(prof_courses_in_subject, "average_professor", "professor_percentile_subject")
        get_stats(prof_courses_in_subject, "average_professor", true)
    
        workload_courses_in_subject = courses_in_subject.select {|course| course.average_workload != nil}
        get_percentile(workload_courses_in_subject, "average_workload", "workload_percentile_subject")
        get_stats(workload_courses_in_subject, "average_workload", true)
    
        prof_same_courses_in_subject = courses_in_subject.select {|course| course.average_rating_same_professors != nil}
        get_percentile(prof_same_courses_in_subject, "average_rating_same_professors", "same_professor_total_rating_percentile_subject")
        get_stats(prof_same_courses_in_subject, "average_rating_same_professors", true)
    
        workload_same_courses_in_subject = courses_in_subject.select {|course| course.average_workload_same_professors != nil}
        get_percentile(workload_same_courses_in_subject, "average_workload_same_professors", "same_professor_workload_percentile_subject")
        get_stats(workload_same_courses_in_subject, "average_workload_same_professors", true)
    
    end
    ## UPDATE TERMIAL PROMPT
    total_counter += 1
    puts "Done!"
end

