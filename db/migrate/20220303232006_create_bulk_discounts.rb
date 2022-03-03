class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :merchant_id
      t.integer :percentage
      t.integer :threshold

      t.timestamps
    end
  end
end
