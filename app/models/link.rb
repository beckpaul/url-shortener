class Link < ApplicationRecord
  has_many :views, dependent: :destroy
  validates :url, presence: true

  scope :recent_first, -> {order(created_at: :desc) }

  after_save_commit if: :url_previously_changed? do
    MetadataJob.perform_later(to_param)
    FaviconSamplingJob.perform_later(to_param)
  end


  def to_param
    ShortCode.encode(id)
  end

  def find
    super ShortCode.decode(id)
  end

  def domain
    URI(url).host rescue StandardError::InvalidURIError
  end

end
