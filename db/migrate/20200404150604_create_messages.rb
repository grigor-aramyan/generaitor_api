class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.bigint :receiver_id
      t.boolean :red, null: false, default: false

      t.timestamps
    end
  end
end
