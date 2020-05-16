class AddRedFlagToFeedbacks < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :red, :boolean, :default => false
  end
end
