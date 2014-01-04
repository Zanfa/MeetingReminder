class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :google_id
      t.string :email
      t.string :access_token
      t.string :refresh_token

      t.timestamps
    end
  end
end
