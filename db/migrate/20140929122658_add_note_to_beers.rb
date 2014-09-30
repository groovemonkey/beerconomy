class AddNoteToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :note, :string
  end
end
