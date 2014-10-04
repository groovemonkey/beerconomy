class AddBeersOfferedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :beersOffered, :string, :array => true, default: '{}'
  end
end
