class CreateFeedbacksSums < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks_sums, id: false do |t|
      t.bigint :id, null: false
      t.text :feedback_ids
      t.text :feedback_all
      t.text :summary
      t.boolean :red, null: false, default: false

      t.timestamps
    end

    add_index :feedbacks_sums, :id, unique: true
  end
end
