class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :body, null: false
      t.integer :number
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end

    add_index :messages, [:chat_id, :number], unique: true
  end
end
