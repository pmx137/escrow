class CreateDisputes < ActiveRecord::Migration
  def change
    create_table :disputes do |t|
      t.belongs_to :payment, :default=> 0
      t.integer :complainant_id, :default=> 0
      t.integer :defendant_id, :default=> 0
      t.decimal :amount_to_pay, :precision => 10, :scale=> 2, :default => 0.00
      t.integer :dispute_state, :default=> 0 # 0 - rozpoczęty, 1 - zakonczony przez powoda, 2 zakonczony przez pozwanego
      t.datetime :end_date
      t.string :filename
      t.boolean :is_deleted, :default=> false
      t.boolean :is_ended, :default=> false
      t.text :complaint
      t.text :judgment
      t.timestamps
    end
    add_index :disputes, ['payment_id'], :name=> 'disputes_idx0'
    add_index :disputes, ['payment_id', 'complainant_id'], :name=> 'disputes_idx1'
    add_index :disputes, ['payment_id', 'defendant_id'], :name=> 'disputes_idx2'
  end
end
