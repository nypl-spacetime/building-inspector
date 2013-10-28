namespace :db do

  desc "Give a polygon counts"
  task :generate_flag_count => :environment do
    flags = Flag.select("COUNT(id) as flag_count, polygon_id").group(:polygon_id).order(:polygon_id)
    flags.each do |f|
      p = Polygon.find(f.polygon_id)
      p.flag_count = f.flag_count
      p.save
    end
  end

  desc "Process consensus (nightly)"
  task :calculate_consensus => :environment do
    yes_query = Flag.connection.execute("UPDATE polygons p SET p.consensus = 'yes' WHERE p.consensus IS NULL AND (SELECT COUNT(id) FROM flags f WHERE f.polygon_id = p.id AND f.flag_value = 'yes')/(SELECT COUNT(id) FROM flags f WHERE f.polygon_id = p.id) > 0.75")
    no_query = Flag.connection.execute("UPDATE polygons p SET p.consensus = 'no' WHERE p.consensus IS NULL AND (SELECT COUNT(id) FROM flags f WHERE f.polygon_id = p.id AND f.flag_value = 'no')/(SELECT COUNT(id) FROM flags f WHERE f.polygon_id = p.id) > 0.75")
    fix_query = Flag.connection.execute("UPDATE polygons p SET p.consensus = 'fix' WHERE p.consensus IS NULL AND (SELECT COUNT(id) FROM flags f WHERE f.polygon_id = p.id AND f.flag_value = 'fix')/(SELECT COUNT(id) FROM flags f WHERE f.polygon_id = p.id) > 0.75")
  end
end