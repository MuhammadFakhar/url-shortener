class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.text :long_url, null: false
      t.string :short_url, null: false, unique: true
      t.integer :clicks, default: 0, null: false

      t.timestamps
    end

    add_index :urls, :short_url, unique: true
  end
end
