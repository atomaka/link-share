require 'spec_helper'

describe 'Admin List Links' do
  context 'when not logged in' do
    it 'should not allow access to list links' do
      visit '/manage'
      expect(page.status_code).to be(401)
    end
  end

  context 'when logged in' do
    let!(:sent_link) { create(:link, sent_at: Time.now) }
    let!(:links) { 10.times.collect { create(:link) } }
    before(:each) { basic_auth 'admin', 'password' }

    context 'unsent' do
      it 'should show unsent links by default' do
        visit '/manage'

        expect(page).to_not have_content(sent_link.title)
        links.each { |link| expect(page).to have_content(link.title) }
      end

      it 'should only list unsent links' do
        visit '/manage'
        first('a', text: 'Unsent Links').click

        expect(page).to_not have_content(sent_link.title)
        links.each { |link| expect(page).to have_content(link.title) }
      end
    end

    context 'sent' do
      it 'should only list sent links' do
        visit '/manage'
        first('a', text: 'Sent Links').click

        expect(page).to have_content(sent_link.title)
        links.each { |link| expect(page).to_not have_content(link.title) }
      end
    end

    context 'all' do
      it 'should list all links' do
        visit '/manage'
        first('a', text: 'All Links').click

        expect(page).to have_content(sent_link.title)
        links.each { |link| expect(page).to have_content(link.title) }
      end
    end
  end
end
