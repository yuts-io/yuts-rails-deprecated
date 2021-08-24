class ChangeStudentId < ActiveRecord::Migration[6.1]
  def change
    rename_column :user_reviews, :student_id, :user_id
  end
end
