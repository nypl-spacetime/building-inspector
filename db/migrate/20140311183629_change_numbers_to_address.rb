class ChangeNumbersToAddress < ActiveRecord::Migration
  def up
    rename_column(:polygons, :consensus_numbers, :consensus_address)
    rename_column(:sheets, :consensus_numbers, :consensus_address)
    rename_index :polygons, 'consensus_numbers_index', 'consensus_address_index'
    rename_index :polygons, 'sheet_consensus_numbers_index', 'sheet_consensus_address_index'
  end

  def down
    rename_column(:polygons, :consensus_address, :consensus_numbers)
    rename_column(:sheets, :consensus_address, :consensus_numbers)
    rename_index :polygons, 'consensus_address_index', 'consensus_numbers_index'
    rename_index :polygons, 'sheet_consensus_address_index', 'sheet_consensus_numbers_index'
  end
end
