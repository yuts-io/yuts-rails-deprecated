class AddCourseIdToGrades < ActiveRecord::Migration[6.1]
  def change
    add_column :grades, :course_id, :integer
  end
end
