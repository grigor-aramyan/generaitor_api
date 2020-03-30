class CreateIdeas < ActiveRecord::Migration[6.0]
  def change
    create_table :ideas do |t|
      t.string :field_or_organization
      t.text :idea_description
      t.string :keywords
      t.references :idea_generaitor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
