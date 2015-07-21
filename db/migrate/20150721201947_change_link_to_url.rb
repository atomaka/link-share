class ChangeLinkToUrl < ActiveRecord::Migration
  def change
    rename_column :links, :link, :url
  end
end
