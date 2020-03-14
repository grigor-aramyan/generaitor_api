class CreateIdeaGeneraitors < ActiveRecord::Migration[6.0]
  def change
    create_table :idea_generaitors do |t|
      t.string :full_name
      t.string :avatar_uri
      t.text :description

      t.timestamps
    end
  end
end
