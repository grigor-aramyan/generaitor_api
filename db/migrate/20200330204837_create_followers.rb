class CreateFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :followers do |t|
      t.bigint :followed_by_id
      t.bigint :follower_of_id

      t.timestamps
    end
  end
end
