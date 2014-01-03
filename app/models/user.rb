#encoding: utf-8
class User < ActiveRecord::Base
  has_secure_password
  sanitize_before_save

  before_create { generate_token(:auth_token) }

  include Humanizer
  require_human_on :create, :unless => :bypass_humanizer

  attr_accessor :bypass_humanizer, :remember_me

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  has_many :outgoing_payments, {:class_name=> 'Payment', :foreign_key=> 'payer_id', :conditions=> ['payments.is_deleted=?', false], :order=> 'payments.id desc'}
  has_many :incoming_payments, {:class_name=> 'Payment', :foreign_key=> 'recipient_id', :conditions=> ['payments.is_deleted=?', false], :order=> 'payments.id desc'}
  has_many :dispute_comments

  has_many :complainants, {:class_name=> 'Dispute', :foreign_key=> 'complainant_id'}
  has_many :defendants, {:class_name=> 'Dispute', :foreign_key=> 'defendant_id'}

  def self.activate lockcode
    user = where(['auth_token=?', lockcode]).first
    if user.blank?
      return false
    else
      user.activated_at = Time.now
      user.is_active = true
      return user.save(:validate=> false)
    end
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def self.get_id firstname, lastname, email, account_owner='', account_no='', mobile=''
    email = email.downcase
    user = where(['email=?', email]).first
    if user.blank?
      password = self.password_generate 8, :skip_upper_case=> true
      user = create({:firstname=> firstname,
                     :lastname=> lastname,
                     :email=> email,
                     :account_no => account_no,
                     :account_owner => account_owner,
                     :mobile => mobile,
                     :password => password,
                     :password_confirmation => password,
                     :bypass_humanizer=> true})
      UserMailer.new_payer(user).deliver
    end
    user
  end

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.base64.tr("+/", "-_")
    end while User.exists?(column => self[column])
  end

  def self.password_generate(length=8, options={})
    options[:skip_symbols] = options[:dont_exclude_unfriendly_chars] = true, true
    chars = []
    chars += ("a".."z").to_a unless options[:skip_lower_case]
    chars += ("A".."Z").to_a unless options[:skip_upper_case]
    chars += ("0".."9").to_a unless options[:skip_numbers]
    chars += %w(! @ # $ % ^ & \( \) { } [ ] - _ < > ?) unless options[:skip_symbols]
    chars -= %w(i I o O 0 1 l !) unless options[:dont_exclude_unfriendly_chars]
    chars -= %w($ & + , / : \; = ? @ < > # % { } | ^ ~ [ ] `) if options[:skip_url_unsafe]
    (1..length).collect { chars[rand(chars.size)] }.join
  end
end