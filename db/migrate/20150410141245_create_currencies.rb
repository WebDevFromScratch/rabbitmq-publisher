class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :uuid
      t.json :rates
      t.boolean :consumer_1
      t.boolean :consumer_2
      t.boolean :consumer_3

      t.timestamps
    end
  end
end
