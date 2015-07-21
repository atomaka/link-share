require 'spec_helper'

describe 'Admin Create Links' do
  context 'when not logged in' do
    it 'should not allow access to new link form' do
      visit '/new'
      expect(page.status_code).to be(401)
    end
  end

  context 'when logged in' do
    before(:each) { basic_auth 'admin', 'password' }

    context 'with valid data' do
      let(:link) { build(:link) }

      it 'should allow creation of a link' do
        visit '/new'
        fill_in :link_title, with: link.title
        fill_in :link_url, with: link.url
        click_button 'Submit'

        expect(page).to have_content 'Link has been created'
      end

      it 'should list the new link' do
        visit '/new'
        fill_in :link_title, with: link.title
        fill_in :link_url, with: link.url
        click_button 'Submit'

        expect(page).to have_content link.title
      end
    end

    context 'with invalid data' do
      let(:link) { build(:link, title: '') }

      it 'should not allow link with invalid data' do
        visit '/new'
        fill_in :link_title, with: link.title
        fill_in :link_url, with: link.url
        click_button 'Submit'

        expect(page).to have_content 'Did not pass validations'
      end
    end
  end
end
