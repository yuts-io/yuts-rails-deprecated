class AddWorkAndProfToReview < ActiveRecord::Migration[6.1]
  def change
    add_column :user_reviews, :good_prof, :boolean
    add_column :user_reviews, :good_workload, :boolean
  end
end
