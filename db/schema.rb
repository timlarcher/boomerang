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

ActiveRecord::Schema.define(:version => 20110718141516) do

  create_table "audit", :force => true do |t|
    t.string   "assoc_id",   :null => false
    t.string   "trans_type", :null => false
    t.integer  "invoice_id", :null => false
    t.decimal  "amount",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demos", :force => true do |t|
    t.string   "name"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "payee_client_id"
    t.integer  "payer_client_id"
    t.string   "invoice_number"
    t.date     "invoice_date"
    t.string   "po_number"
    t.date     "po_date"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount"
  end

  create_table "matching", :force => true do |t|
    t.integer  "payee_client_id", :null => false
    t.integer  "payer_client_id", :null => false
    t.decimal  "amount",          :null => false
    t.string   "status",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount_paid"
  end

  create_table "users", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "handle"
    t.string  "email"
    t.string  "encrypted_password"
    t.string  "password_salt"
    t.boolean "admin",              :default => false
    t.integer "client_id"
  end

end
