require 'spec_helper'

describe 'Admin Send Links' do
  context 'when not logged in' do
    it 'should not allow access to send links' do
      visit '/send'
      expect(page.status_code).to be(401)
    end
  end

  context 'when logged in' do
    let!(:links) { 10.times.collect { create(:link) } }
    before(:each) do
      basic_auth 'admin', 'password'
      allow(SmsNotifier).to receive(:notify)
    end

    it 'should allow sending of a link' do
      visit '/manage'
      first('a', text: 'Send').click
      expect(page).to have_content('Link has been marked as sent')
    end

    it 'should remove sent link from unsent list' do
      link = create(:link)

      visit '/manage'

      find('a', text: link.title)
        .find(:xpath, '../..')
        .find('a', text: 'Send')
        .click

      expect(page).to_not have_content(link.title)
    end

    it 'attempts to send an SMS message' do
      visit '/manage'
      first('a', text: 'Send').click
      expect(SmsNotifier).to have_received(:notify)
    end
  end
end
