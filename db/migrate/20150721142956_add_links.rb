class AddLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :links do |t|
      t.string :title
      t.string :link
      t.datetime :sent_at

      t.timestamps null: false
    end
  end
end
