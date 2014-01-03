class DisputeComment < ActiveRecord::Base
  belongs_to :dispute
  belongs_to :payment
  belongs_to :user

  delegate :full_name, :email, :to => :user, :prefix=> true
end