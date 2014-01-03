#encoding: utf-8
require 'spec_helper'
describe PaymentsController do
  describe '.new_payment' do
    render_views
    before(:each) do
      @payment = Payment.new
    end

    it "should show title 'Poproś o zaliczkę' if params[:id] eq 1" do
      visit new_payment_path(1)
      page.should have_button('Poproś o zaliczkę')

    end

    it "should show title 'Wpłać zaliczkę' if params[:id] !eq 1" do
      visit new_payment_path
      page.should have_button('Wpłać zaliczkę')
    end

  end
end