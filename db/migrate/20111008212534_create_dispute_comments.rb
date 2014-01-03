class CreateDisputeComments < ActiveRecord::Migration
  def change
    create_table :dispute_comments do |t|
      t.belongs_to :payment
      t.belongs_to :dispute
      t.belongs_to :user
      t.string :filename
      t.string :ip, :limit=> 32
      t.text :body
      t.timestamps
    end
    add_index :dispute_comments, ['dispute_id']
  end
end
