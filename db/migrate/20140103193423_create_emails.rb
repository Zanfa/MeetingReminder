class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.text :headers
      t.text :text
      t.text :html
      t.string :from
      t.string :to
      t.string :cc
      t.string :subject

      t.timestamps
    end
  end
end
