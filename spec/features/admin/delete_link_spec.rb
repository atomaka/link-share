require 'spec_helper'

describe 'Admin Delete Links' do
  context 'when not logged in' do
    it 'should not allow access to delete links' do
      visit '/send'
      expect(page.status_code).to be(401)
    end
  end

  context 'when logged in' do
    let!(:links) { 10.times.collect { create(:link) } }
    before(:each) { basic_auth 'admin', 'password' }

    it 'should allow deleting of a link' do
      visit '/manage'
      first('a', text: 'Delete').click
      expect(page).to have_content('Link has been deleted')
    end

    it 'should remove deleted link all lists' do
      link = create(:link)

      visit '/manage'

      find('a', text: link.title)
        .find(:xpath, '../..')
        .find('a', text: 'Delete')
        .click

      visit '/manage?status=all'

      expect(page).to_not have_content(link.title)
    end
  end
end
