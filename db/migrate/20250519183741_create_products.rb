class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
