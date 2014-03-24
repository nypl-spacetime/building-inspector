class MovePolygonConsensusToConsensusTable < ActiveRecord::Migration
  def up
    # move data
    # Polygon.find_each do |polygon|
    #   if polygon.consensus != nil
    #     polygon.consensuspolygons.create(
    #     :consensus => polygon.consensus,
    #     :task => "geometry",
    #     :polygon_id => polygon.id
    #     )
    #   end
    # end
  end
end
