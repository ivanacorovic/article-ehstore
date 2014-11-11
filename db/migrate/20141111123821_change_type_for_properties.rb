class ChangeTypeForProperties < ActiveRecord::Migration
  def change
    remove_column :products, :properties, :hstore
    add_column :products, :properties, :json
  end
end
