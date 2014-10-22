class RemoveConsensusColumns < ActiveRecord::Migration
  def change
    remove_column(:polygons, :consensus) if column_exists? :polygons, :consensus
    remove_column(:polygons, :consensus_address) if column_exists? :polygons, :consensus_address
    remove_column(:polygons, :consensus_polygonfix) if column_exists? :polygons, :consensus_polygonfix
    remove_column(:polygons, :consensus_polygonfix_value) if column_exists? :polygons, :consensus_polygonfix_value
    remove_column(:sheets, :consensus_address) if column_exists? :sheets, :consensus_address
    remove_column(:sheets, :consensus_polygonfix) if column_exists? :sheets, :consensus_polygonfix
    remove_column(:sheets, :consensus) if column_exists? :sheets, :consensus
    remove_column(:sheets, :map_url) if column_exists? :sheets, :map_url
  end
end
