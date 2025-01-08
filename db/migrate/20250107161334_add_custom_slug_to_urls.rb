class AddCustomSlugToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :custom_slug, :string, unique: true
    add_index :urls, :custom_slug, unique: true
  end
end
