class Course < ApplicationRecord
    scope :filter_by_gut_index, -> { where("gut_index > 80")}

    has_many :user_reviews
    has_many :users, through: :user_reviews
    has_many :grades
    
    def self.search(search, season)
        if search
            where("season_code = ? AND (title LIKE ? OR course_code LIKE ? OR professor_names LIKE ?)", "#{season}", "%#{search.titleize}%", "%#{search.upcase}%", "%#{search.titleize}%").order(course_code: :asc)
        else
            where("season_code = ?", "#{season}").order(course_code: :asc).limit(250)
        end
    end

    def self.filter
        where("season_code = 202103 AND gut_index > 70")
    end

    def checkIfBlank(attr, tba=false)
        if self[attr] == "" || self[attr] == nil
            if tba
                "TBA"
            else
                "N/A"
            end
        else
            self[attr]
        end
    end


    def cleanOneStat(attr, rank=false)
        result = self.checkIfBlank(attr)

        result == "N/A" ? result = "N/A" : result = self[attr].round(2)

        if rank 
            if result != "N/A"
                result = result.round.ordinalize 
            end
        end
        result
    end

    def classifyGut 
        if (self["gut_percentile"] == nil || self["gut_percentile_subject"] == nil) 
            return "N/A"
        
        elsif (self["gut_percentile"] >= 75 && self["gut_percentile_subject"] >= 50 && (self["workload_percentile"] != nil && self["workload_percentile"] <= 25) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] <= 50) && (self["professor_percentile"] != nil && self["professor_percentile"] >= 75) && (self["professor_percentile_subject"] != nil && self["professor_percentile_subject"] >= 50)) 
            return "Gut"
           
        elsif ((100 >= self["gut_percentile"] && self["gut_percentile"] >= 67) || (100 >= self["gut_percentile_subject"] && self["gut_percentile_subject"] >= 67)) 
            return "Relaxed"
        
        elsif ((67 > self["gut_percentile"] && self["gut_percentile"] > 33) || (67 > self["gut_percentile_subject"] && self["gut_percentile"] > 33)) 
            return "Average"
        
        elsif (self["gut_percentile"] <= 25 && self["gut_percentile_subject"] < 50 && (self["workload_percentile"] != nil && self["workload_percentile"] >= 75) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] > 50) && (self["professor_percentile"] != nil && self["professor_percentile"] <= 25) && (self["professor_percentile_subject"] != nil && self["professor_percentile_subject"] < 50)) 
            return "Grueling"
        else 
        # case when (33 >= course["gut_percentile"] >= 0) || (33 >= course["gut_percentile_subject"] >= 0)
            return "Challenging"
        end
    end
        
    def classifyProf 
        if (self["professor_percentile"] == nil || self["professor_percentile_subject"] == nil) 
            return "N/A"
        
        elsif (self["professor_percentile"] >= 75 && self["professor_percentile_subject"] >= 50 && (self["workload_percentile"] != nil && self["workload_percentile"] <= 25) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] <= 50) && (self["professor_percentile"] != nil && self["professor_percentile"] >= 75)) 
            return "Exceptional"
        elsif ((100 >= self["professor_percentile"] && self["professor_percentile"] >= 67) || (100 >= self["professor_percentile_subject"] && self["professor_percentile_subject"] >= 67)) 
            return "Good"
        
        elsif ((67 > self["professor_percentile"] && self["professor_percentile"] > 33) || (67 > self["professor_percentile_subject"] && self["professor_percentile"] > 33)) 
            return "Average"
        
        elsif (self["professor_percentile"] <= 25 && self["professor_percentile_subject"] < 50 && (self["workload_percentile"] != nil && self["workload_percentile"] >= 75) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] > 50) && (self["professor_percentile"] != nil && self["professor_percentile"] <= 25)) 
            return "Harsh"
        else 
        # // case when (33 >= self["gut_percentile"] >= 0) || (33 >= self["gut_percentile_subject"] >= 0)
            return "Tough"
        end
    end
        
    

    def classifyWork 
        if (self["workload_percentile"] == nil || self["workload_percentile_subject"] == nil) 
            return "N/A"
        
        elsif (self["workload_percentile"] >= 67 && self["workload_percentile_subject"] >= 67) 
            return "Heavy"
           
        elsif ((67 > self["workload_percentile"] && self["workload_percentile"] >= 33) && (67 > self["workload_percentile_subject"] && self["workload_percentile_subject"] >= 33)) 
            return "Average"
        
        elsif ((self["workload_percentile"] < 33) && (self["workload_percentile_subject"] < 33)) 
            return "Light"
        
        elsif (self["workload_percentile"] > 50 && self["workload_percentile_subject"] >= 67)
            return "Relatively Harsh"
        
        elsif (self["workload_percentile"] < 50 && self["workload_percentile_subject"] <= 33)
            return "Relatively Light"
        
        else 
        # // case when (33 >= course["gut_percentile"] >= 0) || (33 >= course["gut_percentile_subject"] >= 0)
            return "Relatively Average"
        end
    end

    def combineSkillsAndAreas
        # // combine skills and areas
        if (self.areas == "" && self.skills == "" ) 
            skills_and_areas = "N/A"
        elsif ( self.skills == "") 
            skills_and_areas = self.areas.gsub(',','')
        elsif ( self.areas == "") 
            skills_and_areas = self.skills.gsub(',','')
        
        else 
            skills_and_areas = self.areas.gsub(',','') + " " + self.skills.gsub(',','')
        end
    end
        
    def self.season_to_str(season) 
        season_str = String(season)
    
        year = season_str[0...4]
    
        season_code = season_str[4...6]
   
    
        if (season_code == "01") 
            semester = "Spring"
        
        elsif (season_code == "02") 
            semester = "Summer"
         
        else 
            semester = "Fall"
        
        end
        return semester + " " + year
    end

    def self.getSeasons 
        self.pluck("season_code").uniq.sort.reverse
    end

    def user_reviewed?(user_id)
        all_courses = Course.where("course_code = '#{self.course_code}' ")

        all_courses.each { |course| 
            if (course.users.ids.include? user_id)
                return true
            end 
        }

        false
    end
    
    def get_review(user_id, value)
        review = self.user_reviews.find {|review| review.user_id == user_id}
        if review[value] == true
            "Yes"
        else
            "No"
        end
    end 

    def self.get_average_grade(course_code)


        all_courses = self.where("course_code = '#{course_code}' ")
        all_grades = []

        all_courses.each { |course| 
            if (course.grades.count > 0)
                all_grades += course.grades
            end
        }

        if all_grades.size > 0
            all_grade_vals = all_grades.map { |grade| grade.grade}

            result = (all_grade_vals.sum(0).to_f / all_grades.size).round
        end

        if result == 1 
            return "A"
        elsif result == 2
            return "A-"
        elsif result == 3
            return "B+"
        elsif result == 4
            return "B"
        elsif result == 5
            return "B-"
        elsif result == 6
            return "C+"
        elsif result == 7
            return "C"
        elsif result == 8
            return "C-"
        elsif result == 9
            return "D+"
        elsif result == 10
            return "D"
        elsif result == 11
            return "D-"
        elsif result == 12
            return "F"
        else
            return "N/A"
        end
    end

    def self.count_submitted_grades(course_code)
        all_courses = self.where("course_code = '#{course_code}' ")
        all_vals = 0

        all_courses.each { |course| 
            if (course.grades.size != nil)
                all_vals += course.grades.size
            end
        }

        all_vals
    end

    def self.count_review_val(value, course_code)
        all_courses = self.where("course_code = '#{course_code}' ")
        all_vals = 0

        all_courses.each { |course| 

            course.user_reviews.each {|review|
                if ([true, false].include? review[value])
                    all_vals += 1
                end
                
            }

        }

        all_vals
    end

    def self.get_percent_yes(value, course_code)
        all_courses = self.where("course_code = '#{course_code}' ")
        all_vals = 0
        yes_vals = 0

        all_courses.each { |course| 

            course.user_reviews.each {|review|
                if ([true, false].include? review[value])
                    if review[value] == true
                        yes_vals += 1
                    end
                    all_vals += 1
                end
                
            }

        }
        if all_vals > 0
            String(((yes_vals.to_f / all_vals) * 100).round) + "%"
        else
            "N/A"
        end
    end

    
    

end
