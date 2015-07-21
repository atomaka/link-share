require 'spec_helper'

describe 'Calendar View' do
  OVER_ONE_MONTH = 60*60*24*40

  let!(:showing_link) { create(:link, sent_at: Time.now) }
  let!(:before_link) { create(:link, sent_at: Time.now - OVER_ONE_MONTH) }
  let!(:after_link) { create(:link, sent_at: Time.now + OVER_ONE_MONTH) }

  it 'should only show links for the current month', js: true do
    visit '/'

    expect(page).to have_content(showing_link.title)
    expect(page).to_not have_content(before_link.title)
    expect(page).to_not have_content(after_link.title)
  end
end
