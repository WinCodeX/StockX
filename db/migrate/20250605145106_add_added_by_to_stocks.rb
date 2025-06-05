class AddAddedByToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :added_by, :string
  end
end
