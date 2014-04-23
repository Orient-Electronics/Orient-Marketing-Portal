class Announcement < ActiveRecord::Base
  include PublicActivity::Common
  attr_accessible :announcement
end


