class CreateMyApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :my_applications do |t|
      t.string :name
      t.string :token
      t.integer :chats_count, default: 0

      t.timestamps
    end
    add_index :my_applications, :token, unique: true
  end
end
