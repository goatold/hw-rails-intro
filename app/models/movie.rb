class Movie < ActiveRecord::Base
    def similar
        return nil if director.nil? or director.blank?
        Movie.where(director: director)
    end
end
