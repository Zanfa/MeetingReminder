class AddNotifyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :notify, :boolean
  end
end
