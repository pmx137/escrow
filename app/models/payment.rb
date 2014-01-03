class Payment < ActiveRecord::Base
  include Humanizer
  require_human_on :create, :unless => :bypass_humanizer

  before_create :check_users
  before_create :gen_url_token

  attr_accessor :p_email, :p_firstname, :p_lastname, :p_account_owner, :p_account_no, :p_mobile
  attr_accessor :r_email, :r_firstname, :r_lastname, :r_mobile, :bypass_humanizer

  validates_presence_of :title
  validates_presence_of :p_email, :if => Proc.new { |p| p.new_record? }
  validates_format_of :p_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => Proc.new { |p| p.new_record? }

  validates_numericality_of :amount, :greater_than => 0

  has_one :payer, :class_name=> 'User', :foreign_key=> 'id', :primary_key=> 'payer_id'
  has_one :recipient, :class_name=> 'User', :foreign_key=> 'id', :primary_key=> 'recipient_id'
  has_one :dispute

  delegate :amount_to_pay, :complainant_id, :defendant_id, :dispute_state, :complaint, :judgment, :created_at,
           :end_date, :is_ended, :to=> :dispute, :prefix=> true

  delegate :full_name, :firstname, :email, :account_owner, :account_no, :to=> :payer, :prefix=> true
  delegate :full_name, :firstname, :email, :account_owner, :account_no, :to=> :recipient, :prefix=> true

  scope :by_url_token, lambda { |url_token| {:conditions => ["payments.url_token=?", url_token], :limit=> 1, :include=> [:payer, :recipient]} }
  scope :payer_and_url_token, lambda { |id, url_token| {:conditions => ["payments.payer_id=? AND payments.url_token=?", id, url_token], :limit=> 1} }
  scope :recipient_and_url_token, lambda { |id, url_token| {:conditions => ["payments.recipient_id=? AND payments.url_token=?", id, url_token], :limit=> 1} }

  def check_users
    payer = User.get_id(self.p_firstname, self.p_lastname, self.p_email, '', '', self.p_mobile)
    self.payer_id = payer.id
    recipient = User.get_id(self.r_firstname, self.r_lastname, self.r_email, self.r_account_owner, self.r_account_no)
    self.recipient_id = recipient.id
  end

  def gen_url_token
    begin
      self[:url_token] = SecureRandom.hex(10)
    end
  end
end