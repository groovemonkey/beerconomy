class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :passhash
      t.string :email
      t.integer :beersGiven, :array => true
      t.integer :beersReceived, :array => true

      t.timestamps
    end
  end
end
