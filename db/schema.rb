# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_24_015944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "all_course_codes"
    t.string "areas"
    t.float "average_gut_rating"
    t.float "average_professor"
    t.float "average_rating"
    t.float "average_workload"
    t.float "average_rating_same_professors"
    t.float "average_workload_same_professors"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "classnotes"
    t.string "course_code"
    t.float "credits"
    t.integer "crn"
    t.text "description"
    t.integer "enrolled"
    t.string "extra_info"
    t.string "final_exam"
    t.string "flag_info"
    t.boolean "fysem"
    t.integer "last_enrollment"
    t.boolean "last_enrollment_same_professors"
    t.integer "listing_id"
    t.string "locations_summary"
    t.string "number"
    t.string "professor_names"
    t.text "regnotes"
    t.text "requirements"
    t.text "rp_attr"
    t.string "school"
    t.integer "season_code"
    t.integer "section"
    t.string "skills"
    t.string "subject"
    t.string "syllabus_url"
    t.string "times_summary"
    t.string "title"
    t.float "gut_index"
    t.integer "gut_percentile"
    t.integer "professor_percentile"
    t.integer "workload_percentile"
    t.integer "same_professor_total_rating_percentile"
    t.integer "same_professor_workload_percentile"
    t.integer "gut_percentile_subject"
    t.integer "professor_percentile_subject"
    t.integer "workload_percentile_subject"
    t.integer "same_professor_total_rating_percentile_subject"
    t.integer "same_professor_workload_percentile_subject"
    t.float "gut_index_mean"
    t.float "gut_index_median"
    t.float "gut_index_standard_deviation"
    t.float "gut_index_mode"
    t.float "gut_index_range"
    t.float "average_professor_mean"
    t.float "average_professor_median"
    t.float "average_professor_standard_deviation"
    t.float "average_professor_mode"
    t.float "average_professor_range"
    t.float "average_workload_mean"
    t.float "average_workload_median"
    t.float "average_workload_standard_deviation"
    t.float "average_workload_mode"
    t.float "average_workload_range"
    t.float "average_rating_same_professors_mean"
    t.float "average_rating_same_professors_median"
    t.float "average_rating_same_professors_standard_deviation"
    t.float "average_rating_same_professors_mode"
    t.float "average_rating_same_professors_range"
    t.float "average_workload_same_professors_mean"
    t.float "average_workload_same_professors_median"
    t.float "average_workload_same_professors_standard_deviation"
    t.float "average_workload_same_professors_mode"
    t.float "average_workload_same_professors_range"
    t.float "gut_index_subject_mean"
    t.float "gut_index_subject_median"
    t.float "gut_index_subject_standard_deviation"
    t.float "gut_index_subject_mode"
    t.float "gut_index_subject_range"
    t.float "average_professor_subject_mean"
    t.float "average_professor_subject_median"
    t.float "average_professor_subject_standard_deviation"
    t.float "average_professor_subject_mode"
    t.float "average_professor_subject_range"
    t.float "average_workload_subject_mean"
    t.float "average_workload_subject_median"
    t.float "average_workload_subject_standard_deviation"
    t.float "average_workload_subject_mode"
    t.float "average_workload_subject_range"
    t.float "average_rating_same_professors_subject_mean"
    t.float "average_rating_same_professors_subject_median"
    t.float "average_rating_same_professors_subject_standard_deviation"
    t.float "average_rating_same_professors_subject_mode"
    t.float "average_rating_same_professors_subject_range"
    t.float "average_workload_same_professors_subject_mean"
    t.float "average_workload_same_professors_subject_median"
    t.float "average_workload_same_professors_subject_standard_deviation"
    t.float "average_workload_same_professors_subject_mode"
    t.float "average_workload_same_professors_subject_range"
  end

  create_table "grades", force: :cascade do |t|
    t.string "grade"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_reviews", force: :cascade do |t|
    t.integer "course_id"
    t.integer "student_id"
    t.boolean "is_a_gut"
    t.boolean "enjoyed_class"
    t.boolean "submitted_grade"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_token"
    t.string "google_refresh_token"
  end

end
