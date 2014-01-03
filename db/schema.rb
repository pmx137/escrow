# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111008212534) do

  create_table "dispute_comments", :force => true do |t|
    t.integer  "dispute_id"
    t.integer  "user_id"
    t.string   "filename"
    t.string   "ip",         :limit => 32
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_id",               :default => 0
  end

  add_index "dispute_comments", ["dispute_id"], :name => "index_dispute_comments_on_dispute_id"

  create_table "disputes", :force => true do |t|
    t.integer  "payment_id",                                    :default => 0
    t.integer  "complainant_id",                                :default => 0
    t.integer  "defendant_id",                                  :default => 0
    t.decimal  "amount_to_pay",  :precision => 10, :scale => 2, :default => 0.0
    t.integer  "dispute_state",                                 :default => 0
    t.datetime "end_date"
    t.string   "filename"
    t.boolean  "is_deleted",                                    :default => false
    t.boolean  "is_ended",                                      :default => false
    t.text     "complaint"
    t.text     "judgment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "disputes", ["payment_id", "complainant_id"], :name => "disputes_idx1"
  add_index "disputes", ["payment_id", "defendant_id"], :name => "disputes_idx2"
  add_index "disputes", ["payment_id"], :name => "disputes_idx0"

  create_table "payments", :force => true do |t|
    t.integer  "payer_id",                                                     :default => 0
    t.integer  "recipient_id",                                                 :default => 0
    t.string   "title"
    t.decimal  "amount",                        :precision => 10, :scale => 2, :default => 0.0
    t.datetime "end_date"
    t.datetime "payment_date"
    t.integer  "payment_state",   :limit => 2,                                 :default => -1
    t.boolean  "is_deleted",                                                   :default => false
    t.boolean  "is_disputed",                                                  :default => false
    t.string   "service_url"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip",              :limit => 32
    t.string   "url_token",       :limit => 42
    t.string   "r_account_no",    :limit => 64,                                :default => ""
    t.string   "r_account_owner",                                              :default => ""
    t.boolean  "is_asked",                                                     :default => false
  end

  add_index "payments", ["is_deleted"], :name => "index_payments_on_is_deleted"
  add_index "payments", ["is_disputed"], :name => "index_payments_on_is_disputed"
  add_index "payments", ["payer_id"], :name => "index_payments_on_payer_id"
  add_index "payments", ["payment_state"], :name => "index_payments_on_payment_state"
  add_index "payments", ["recipient_id"], :name => "index_payments_on_recipient_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :limit => 128
    t.string   "firstname",              :limit => 128
    t.string   "lastname",               :limit => 128
    t.string   "account_owner",          :limit => 128, :default => ""
    t.string   "account_no",             :limit => 64
    t.string   "mobile",                 :limit => 32
    t.integer  "opinion",                               :default => 0
    t.string   "ip",                     :limit => 16,  :default => "0.0.0.0"
    t.integer  "user_state",                            :default => 0
    t.string   "password_digest"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.boolean  "is_active",                             :default => false
    t.boolean  "is_deleted",                            :default => false
    t.datetime "password_reset_sent_at"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id"], :name => "index_users_on_id"

end
