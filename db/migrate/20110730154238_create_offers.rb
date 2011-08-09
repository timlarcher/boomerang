class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.string :type
      t.integer :client_id
      t.integer :user_id
      t.integer :quantity
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end
