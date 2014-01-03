class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :limit=> 128
      t.string :firstname, :limit => 128
      t.string :lastname, :limit => 128
      t.string :account_owner, :limit=> 128, :default=> ''
      t.string :account_no, :limit => 64
      t.string :mobile, :limit => 32
      t.integer :opinion, :default => 0
      t.string :ip, :limit=> 16, :default=> '0.0.0.0'
      t.integer :user_state, :limit=> 3, :default=> 0
      t.string :password_digest
      t.string :password_hash
      t.string :password_salt
      t.string :auth_token
      t.string :password_reset_token
      t.boolean :is_active, :default=> false
      t.boolean :is_deleted, :default=> false
      t.datetime :password_reset_sent_at
      t.datetime :activated_at
      t.timestamps
    end
    add_index :users, ['id']
    add_index :users, ['email']
  end
end
