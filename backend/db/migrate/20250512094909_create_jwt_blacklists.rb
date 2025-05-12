class CreateJwtBlacklists < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_blacklists do |t|
      t.string :token, null: false
      t.datetime :exp, null: false

      t.timestamps
    end

    add_index :jwt_blacklists, :token, unique: true
  end
end
