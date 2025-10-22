class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :chats, [ :sender_id, :recipient_id ], unique: true
  end
end
