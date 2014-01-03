class Dispute < ActiveRecord::Base
  after_initialize :default_values

  attr_accessor :old_complaint

  before_save :set_complaint, :unless=> Proc.new { |dispute| dispute.new_record? }

  belongs_to :payment
  has_many :dispute_comments, :order=> 'id ASC'

  has_one :complainant, :class_name=> 'User', :foreign_key=> 'id', :primary_key=> 'complainant_id'
  has_one :defendant, :class_name=> 'User', :foreign_key=> 'id', :primary_key=> 'defendant_id'

  delegate :full_name, :email, :to => :user, :prefix=> true

  scope :by_payment, lambda { |payment_id| {:conditions => ["payment_id=?", payment_id], :limit=> 1} }

  private

  def default_values
    self.end_date ||= Time.now+4.days
    self.old_complaint = self.complaint

  end

  def set_complaint
    unless self.complaint.blank?
      self.old_complaint.to_s << "\n\n [#{Time.now.strftime('%d.%m.%Y')}]\n\n"
      self.complaint = self.old_complaint.to_s << self.complaint
    else
      self.complaint = self.old_complaint
    end
  end
end
