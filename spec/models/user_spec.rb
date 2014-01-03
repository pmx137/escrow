require "spec_helper"

describe User do
  it 'should be valid' do
    user = FactoryGirl.create(:user)
    user.should be_valid
  end

  it "should require an email" do
    FactoryGirl.build(:user, :email => '').should_not be_valid
  end


end