class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :tag, null: false
      t.integer :status, null: false, default: 0
      t.string :low_frequency_tags, array: true
      t.string :middle_frequency_tags, array: true
      t.string :high_frequency_tags, array: true

      t.timestamps
    end
  end
end
