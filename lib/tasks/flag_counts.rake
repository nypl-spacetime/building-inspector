namespace :db do
  desc "Generate all flag counts"
  task :import_all => [:generate_flag_count, :bulk_import]

  desc: "Bulk import"
  task :bulk_import => :environment do
    puts "insert task code here"
  end

  desc: "Give a polygon counts"
  task :generate_flag_count => :environment do
    for poly in Polygons.all
      if poly.invitation_id.nil?
        invite = Invitation.create(:sender_id => <some id>, :recipient_email => <some email>, :token => <some token>, :sent_at => Time.now)
        poly.update_attribute(:invitation_id, invite.id)
        puts "Updated poly #{poly.id} with invitation_id #{invite.id}"
      else
        puts "poly already has an invitation_id"
      end
    end
  end
end