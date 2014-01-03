class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :payer_id, :default=> 0
      t.integer :recipient_id, :default=> 0
      t.string :title
      t.decimal :amount, :precision => 10, :scale=> 2, :default => 0.00
      t.datetime :end_date #data zakonczenia zlecenia
      t.datetime :payment_date #data zaplaty
      t.integer :payment_state, :limit=> 2, :default=> -1 #-1 new (not paid), 0 money on account, 1 paid for recipient
      t.boolean :is_deleted, :default=> false
      t.boolean :is_asked, :default=> false
      t.boolean :is_disputed, :default=> false
      t.string :url_token, :limit=> 42
      t.string :service_url
      t.string :r_account_no, :limit=> 64
      t.string :r_account_owner
      t.string :ip, :limit=> 32
      t.text :details
      t.timestamps
    end
    add_index :payments, ['payer_id']
    add_index :payments, ['recipient_id']
    add_index :payments, ['payment_state']
    add_index :payments, ['is_deleted']
    add_index :payments, ['url_token']
    add_index :payments, ['is_disputed']
  end
end
