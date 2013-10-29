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
    yes_query = Flag.connection.execute("UPDATE polygons SET consensus = 'yes' WHERE consensus IS NULL AND flag_count >= 3 AND ((SELECT COUNT(id) FROM flags WHERE flags.polygon_id = polygons.id AND flags.flag_value = 'yes')::float/polygons.flag_count::float) >= 0.75")
    no_query = Flag.connection.execute("UPDATE polygons SET consensus = 'no' WHERE consensus IS NULL AND flag_count >= 3 AND ((SELECT COUNT(id) FROM flags WHERE flags.polygon_id = polygons.id AND flags.flag_value = 'no')::float/polygons.flag_count::float) >= 0.75")
    fix_query = Flag.connection.execute("UPDATE polygons SET consensus = 'fix' WHERE consensus IS NULL AND flag_count >= 3 AND ((SELECT COUNT(id) FROM flags WHERE flags.polygon_id = polygons.id AND flags.flag_value = 'fix')::float/polygons.flag_count::float) >= 0.75")
  end
end