class CreateUserReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :user_reviews do |t|
      t.integer :course_id
      t.integer :student_id
      t.boolean :is_a_gut
      t.boolean :enjoyed_class
      t.boolean :submitted_grade



      t.timestamps
    end
  end
end
