module ActiveRecordExtension
	extend ActiveSupport::Concern
	module ClassMethods
		def random
			if (c = count) != 0
				find(:first, :offset =>rand(c))
			end
		end
	end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)