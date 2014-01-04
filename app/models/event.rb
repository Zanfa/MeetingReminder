class Event < ActiveRecord::Base

  validates_uniqueness_of :google_id

  belongs_to :user

end
