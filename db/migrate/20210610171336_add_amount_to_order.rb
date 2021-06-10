class AddAmountToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :amount, :decimal
  end
end
