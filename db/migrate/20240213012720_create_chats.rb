class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :number
      t.integer :messages_count, default: 0
      t.references :my_application, null: false, foreign_key: true

      t.timestamps
    end

    add_index :chats, [:my_application_id, :number], unique: true
  end
end
