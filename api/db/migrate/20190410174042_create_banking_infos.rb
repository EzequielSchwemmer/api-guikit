class CreateBankingInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :banking_infos do |t|
      t.string :bank_name, null: false
      t.string :cbu
      t.string :bank_alias
      t.string :cuit, null: false
      t.references :user, null: false, foreign_key: true, index: {unique: true}

      t.timestamps
    end
  end
end
