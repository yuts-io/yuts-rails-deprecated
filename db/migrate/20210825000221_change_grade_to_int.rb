class ChangeGradeToInt < ActiveRecord::Migration[6.1]
  def change
    remove_column :grades, :grade
    add_column :grades, :grade, :integer
  end
end
