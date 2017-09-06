class ChangeLinkToUrl < ActiveRecord::Migration[4.2]
  def change
    rename_column :links, :link, :url
  end
end
