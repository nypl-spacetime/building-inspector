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
end