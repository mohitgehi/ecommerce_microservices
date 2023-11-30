class CreateLineItems < ActiveRecord::Migration[7.1]
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.decimal :price
      t.integer :quantity

      t.timestamps
    end

    add_reference :line_items, :order, foreign_key: true
  end
end
