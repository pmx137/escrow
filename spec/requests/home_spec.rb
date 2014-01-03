require 'spec_helper'

describe 'Home' do
  describe "GET /index" do
    it 'should responsce with status ok' do
      get home_path
      response.status.should be(200)
    end
  end
end