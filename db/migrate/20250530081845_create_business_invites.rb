class CreateBusinessInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :business_invites do |t|
      t.string :code
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.references :business, null: false, foreign_key: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
