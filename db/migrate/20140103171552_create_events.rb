class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :participants, array: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :user_id
      t.string :google_id

      t.timestamps
    end
  end
end
