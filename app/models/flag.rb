class Flag < ActiveRecord::Base
    belongs_to :flaggable, polymorphic: true
    has_one :usersession, :foreign_key => :session_id, :primary_key => :session_id
    attr_accessible :flag_value, :is_primary, :flaggable_type, :flaggable_id, :session_id, :flag_type, :latitude, :longitude
    validates :flag_value, presence: true
    validates :flaggable_type, presence: true
    validates :flaggable_id, presence: true
    validates :flag_type, presence: true

    def self.flags_for_sheet_for_session(sheet_id, session_id, type = "geometry")
        # just need the count
        if type != "toponym"
            Flag.select('DISTINCT flags.flaggable_id, flags.id, flags.session_id, flags.flag_type, flags.flaggable_type, flags.latitude, flags.longitude, flags.flag_value, polygons.geometry, polygons.sheet_id, polygons.dn').joins("INNER JOIN polygons ON polygons.id = flags.flaggable_id INNER JOIN sheets ON sheets.id = polygons.sheet_id").where('sheets.id = ? AND flags.session_id = ? AND flags.flag_type = ?', sheet_id, session_id, type)
        else
            # constrain flags to sheet bounding box
            s = Sheet.find(sheet_id)
            bbox = s[:bbox].split(",")
            w = bbox[0]
            s = bbox[1]
            e = bbox[2]
            n = bbox[3]
            Flag.select('DISTINCT flags.flaggable_id, flags.id, flags.session_id, flags.flag_type, flags.flaggable_type, flags.latitude, flags.longitude, flags.flag_value').joins("INNER JOIN sheets ON sheets.id = flags.flaggable_id").where('(flags.flaggable_id = ? OR (flags.latitude <= ? AND flags.latitude >= ? AND flags.longitude <= ? AND flags.longitude >= ?)) AND flags.session_id = ? AND flags.flag_type = ?', sheet_id, n, s, e, w, session_id, type)
        end
    end

    def self.flags_for_sheet_for_user(sheet_id, user_id, type = "geometry")
        # just need the count
        if type != "toponym"
            Flag.select('DISTINCT flags.flaggable_id, flags.id, flags.session_id, flags.flag_type, flags.flaggable_type, flags.latitude, flags.longitude, flags.flag_value, polygons.geometry, polygons.sheet_id, polygons.dn').joins("INNER JOIN polygons ON polygons.id = flags.flaggable_id INNER JOIN sheets ON sheets.id = polygons.sheet_id").joins(:usersession).where('sheets.id = ? AND usersessions.user_id = ? AND flags.flag_type = ?', sheet_id, user_id, type)
        else
            # constrain flags to sheet bounding box
            s = Sheet.find(sheet_id)
            bbox = s[:bbox].split(",")
            w = bbox[0]
            s = bbox[1]
            e = bbox[2]
            n = bbox[3]
            Flag.select('DISTINCT flags.flaggable_id, flags.id, flags.session_id, flags.flag_type, flags.flaggable_type, flags.latitude, flags.longitude, flags.flag_value').joins("INNER JOIN sheets ON sheets.id = flags.flaggable_id").joins(:usersession).where('(flags.flaggable_id = ? OR (flags.latitude <= ? AND flags.latitude >= ? AND flags.longitude <= ? AND flags.longitude >= ?)) AND usersessions.user_id = ? AND flags.flag_type = ?', sheet_id, n, s, e, w, user_id, type)
        end
    end

    def self.grouped_flags_for_session(session_id, layer_id, type = "geometry")
        # just need the count per sheet
        if type != "toponym"
            Flag.select('COUNT(DISTINCT flags.flaggable_id) as total, sheets.id, sheets.bbox').joins("INNER JOIN polygons ON polygons.id = flags.flaggable_id INNER JOIN sheets ON sheets.id = polygons.sheet_id").where('flags.session_id = ? AND flags.flag_type = ? AND sheets.layer_id = ?', session_id, type, layer_id).group("sheets.id")
        else
            Flag.select('COUNT(flags.id) as total, sheets.id, sheets.bbox').joins("INNER JOIN sheets ON sheets.id = flags.flaggable_id").where('flags.session_id = ? AND flags.flag_type = ? AND sheets.layer_id = ?', session_id, type, layer_id).group("sheets.id")
        end
    end

    def self.grouped_flags_for_user(user_id, layer_id, type = "geometry")
        # just need the count per sheet
        if type != "toponym"
            Flag.select('COUNT(DISTINCT flags.flaggable_id) as total, sheets.id, sheets.bbox').joins("INNER JOIN polygons ON polygons.id = flags.flaggable_id INNER JOIN sheets ON sheets.id = polygons.sheet_id").joins(:usersession).where('usersessions.user_id = ? AND flags.flag_type = ? AND sheets.layer_id = ?', user_id, type, layer_id).group("sheets.id")
        else
            Flag.select('COUNT(flags.id) as total, sheets.id, sheets.bbox').joins("INNER JOIN sheets ON sheets.id = flags.flaggable_id").joins(:usersession).where('usersessions.user_id = ? AND flags.flag_type = ? AND sheets.layer_id = ?', user_id, type, layer_id).group("sheets.id")
        end
    end

    def self.flags_for_session(session_id, type = "geometry")
        if type != "toponym"
            Flag.select("DISTINCT flaggable_id, flaggable_type").where("session_id = ? AND flag_type = ?", session_id, type).count
        else
            Flag.select("DISTINCT flags.id").where("session_id = ? AND flag_type = ?", session_id, type).count
        end
    end

    def self.flags_for_user(user_id, type = "geometry")
        if type != "toponym"
            Flag.select("DISTINCT flaggable_id, flaggable_type").joins(:usersession).where('usersessions.user_id = ? AND flags.flag_type = ?', user_id, type).count
        else
            Flag.select("DISTINCT flags.id").joins(:usersession).where('usersessions.user_id = ? AND flags.flag_type = ?', user_id, type).count
        end
    end

    # TODO: might not be necessary (not used right now)
    def self.progress_for_session(session_id, type = "geometry")
        if type != "toponym"
            Flag.select("DISTINCT polygons.id, polygons.centroid_lat, polygons.centroid_lon, polygons.geometry, flags.*").joins(:polygon).where("flags.session_id = ? AND flags.flag_type = ?", session_id, type)
        else
            Flag.select("flags.*").joins("INNER JOIN sheets ON sheets.id = flags.flaggable_id").where("flags.session_id = ? AND flags.flag_type = ?", session_id, type)
        end
    end

    # TODO: might not be necessary (not used right now)
    def self.progress_for_user(user_id, type = "geometry")
        if type != "toponym"
            Flag.select("DISTINCT polygons.id, polygons.centroid_lat, polygons.centroid_lon, polygons.geometry, flags.*").joins(:polygon).joins(:usersession).where('usersessions.user_id = ? AND flags.flag_type = ?', user_id, type)
        else
            Flag.select("flags.*").joins("INNER JOIN sheets ON sheets.id = flags.flaggable_id").joins(:usersession).where('usersessions.user_id = ? AND flags.flag_type = ?', user_id, type)
        end
    end

    def self.flags_for_sheet_for_task_and_threshold(sheet_id, task = "polygonfix", threshold = 3, type = "Polygon")
        if type == "Polygon"
            sql = Flag.send(:sanitize_sql_array,["SELECT f.flaggable_id, f.flaggable_type, f.id, f.flag_value FROM flags f INNER JOIN ( SELECT _f.flaggable_id pid, COUNT(*) qty FROM flags _f INNER JOIN polygons _p ON _p.id = _f.flaggable_id AND _f.flag_type =  ? WHERE _p.sheet_id = ? GROUP BY pid HAVING COUNT(*) >= ? ) j1 ON j1.pid = f.flaggable_id WHERE f.flag_type =  ? AND f.flaggable_type = ? ORDER BY f.flaggable_id", task, sheet_id, threshold, task, type])
        else
            sql = Flag.send(:sanitize_sql_array,["SELECT f.flaggable_id, f.flaggable_type, f.id, f.flag_value FROM flags f INNER JOIN ( SELECT _f.flaggable_id sid, COUNT(*) qty FROM flags _f INNER JOIN sheets _s ON _s.id = _f.flaggable_id AND _f.flag_type =  ? WHERE _s.id = ? GROUP BY sid HAVING COUNT(*) >= ? ) j1 ON j1.sid = f.flaggable_id WHERE f.flag_type =  ? AND f.flaggable_type = ? ORDER BY f.flaggable_id", task, sheet_id, threshold, task, type])
        end
        Flag.connection.execute(sql)
    end

    def self.flags_for_sheet_for_task(sheet_id, task = "address", type = "Polygon")
        if type == "Polygon"
            Flag.joins("INNER JOIN polygons ON polygons.id = flags.flaggable_id").where("sheet_id = ? AND flag_type = ? AND latitude IS NOT NULL AND longitude IS NOT NULL AND flaggable_type = ?", sheet_id, task, type)
        else
            Flag.joins("INNER JOIN sheets ON sheets.id = flags.flaggable_id").where("sheets.id = ? AND flag_type = ? AND latitude IS NOT NULL AND longitude IS NOT NULL AND flaggable_type = ?", sheet_id, task, type)
        end
    end

    def self.flags_by_id_for_session(ids, session_id)
        Flag.where("id IN (?) AND session_id = ?", ids, session_id)
    end

    def self.all_as_features(type = "geometry")
        features = []

        f = Flag.where(:flag_type => type)
        f.each do |flag|
            features.push(flag.to_geojson)
        end

        { :type => "FeatureCollection", :features => features }
    end

    def to_geojson
        # commented out the query for user to improve performance
        # user = Usersession.where(:session_id => self[:session_id]).first
        r = {}
        if self[:latitude] == nil || self[:longitude] == nil
            p = self.flaggable
            self[:latitude] = p[:centroid_lat]
            self[:longitude] = p[:centroid_lon]
        end
        r[:type] = "Feature"
        r[:properties] = {}
        r[:properties][:id] = self[:id]
        r[:properties][:flaggable_id] = self.flaggable[:id]
        r[:properties][:flaggable_type] = self[:flaggable_type]
        r[:properties][:flag_type] = self[:flag_type]
        # if user != nil
        #   r[:properties][:user_id] = user[:user_id]
        # else
            r[:properties][:session_id] = self[:session_id]
        # end
        if self[:flag_type] == 'polygonfix' && self[:flag_value] != "NOFIX"
            # NOTE: polygonfix flags are inserted with non-redundant first-last points
            # this has to be added for geojson validation
            geojson = JSON.parse(self[:flag_value])
            if geojson[0].length >= 3
                type = "Polygon"
                geojson[0].push geojson[0][0]
            else
                # remove one level of nesting
                # was: [[[x,y],[x,y]]]
                # becomes: [[x,y],[x,y]]
                geojson = geojson[0]
                type = "LineString"
            end
            r[:geometry] = { :type => type, :coordinates => geojson }
        else
            r[:properties][:flag_value] = self[:flag_value]
            r[:geometry] = { :type => "Point", :coordinates => [self[:longitude].to_f, self[:latitude].to_f] }
        end
        r
    end

end
