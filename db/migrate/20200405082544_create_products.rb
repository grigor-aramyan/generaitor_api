class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :img_uri
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
