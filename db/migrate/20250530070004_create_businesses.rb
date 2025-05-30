class CreateBusinesses < ActiveRecord::Migration[7.1]
  def change
    create_table :businesses do |t|
      t.string :name
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
