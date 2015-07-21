class Link < ActiveRecord::Base
  validates :title,
    presence: true
  validates :url,
    presence: true,
    url: true,
    uniqueness: true

  scope :sent, -> { where('sent_at IS NOT NULL').order('sent_at DESC') }
  scope :unsent, -> { where('sent_at IS NULL').order('created_at ASC') }
  scope :sent_after, ->(date) { where('sent_at > ?', date) }
  scope :sent_before, ->(date) { where('sent_at < ?', date) }
  scope :calendar, ->(start, finish) { sent_after(start).sent_before(finish) }

  def mark_sent
    update_attribute(:sent_at, Time.now)
  end

  def sent?
    !!self.sent_at
  end

  def url=(url)
    url.chomp!('/') if url.respond_to?(:chomp)
    write_attribute(:url, url)
  end
end
