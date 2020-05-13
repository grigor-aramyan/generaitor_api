class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.string :organization_name
      t.boolean :for_product, null: false, default: false
      t.bigint :product_id, null: false, default: -1
      t.text :branch_address
      t.integer :sentiment, null: false, default: 0
      t.string :keywords, default: ''
      t.text :content

      t.timestamps
    end
  end
end
