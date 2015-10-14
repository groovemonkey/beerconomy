class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :passhash
      t.string :email
      t.string :beersGiven, :array => true
      t.string :beersReceived, :array => true

      t.timestamps
    end
  end
end
