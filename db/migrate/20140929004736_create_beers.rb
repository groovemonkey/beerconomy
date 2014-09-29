class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.integer :sponsor
      t.integer :recipient
      t.string :lat
      t.string :lon
      t.string :randID
      t.timestamp :receivedAt

      t.timestamps
    end
  end
end
