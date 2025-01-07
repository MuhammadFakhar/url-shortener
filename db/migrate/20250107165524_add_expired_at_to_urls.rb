class AddExpiredAtToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :expired_at, :datetime
  end
end
