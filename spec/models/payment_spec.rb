require 'spec_helper'

describe Payment do

  it 'should create an user account for payer and recipient' do
    payment = FactoryGirl.create(:new_payment)
    payment.should be_valid
    payment.recipient_id.should_not be eq(0)
    payment.payer_id.should_not be eq(0)
  end

  it 'should create account for recipient' do
    payment = FactoryGirl.create(:pay_for_recipient)
    payment.recipient_id.should be > 0
    payment.recipient.email.should == 'henry@ford.com'
  end

  it 'should create an account for payer' do
    payment = FactoryGirl.create(:ask_for_payment)
    payment.payer_id.should be > 0
    payment.payer.email.should == 'john1@wp.pl'
  end

  it 'should show error messages, when is not valid' do
    payment = Payment.new
    payment.save
    payment.should_not be_valid
  end
end