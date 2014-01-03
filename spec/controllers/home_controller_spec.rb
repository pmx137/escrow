#encoding: utf-8
require 'spec_helper'
describe HomeController do
  describe 'contact' do
    render_views
    it 'should show form with proper fields' do
      visit contact_path
      page.should have_selector('form.formtastic')
      page.has_field? 'message[name]'
      page.has_field? 'message[email]'
      page.has_field? 'message[phone]'
      page.has_field? 'message[content]'
    end

    it 'should send form' do
      visit contact_path
      fill_in('message[name]', :with => 'John')
      fill_in('message[email]', :with => 'joe@doe.com')
      fill_in('message[phone]', :with => '34233434')
      fill_in('message[content]', :with => 'Really Long Text...')
      click_on 'Wyślij wiadomość'
      page.should have_content(I18n.t('message_sent'))
      page.should have_selector('.bar-notice')
    end
      end
end
