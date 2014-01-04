class AddNotifiedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :notified, :boolean, default: false
  end
end
