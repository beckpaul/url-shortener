class Link < ApplicationRecord
  has_many :views, dependent: :destroy
  validates :url, presence: true

  scope :recent_first, -> {order(created_at: :desc) }


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
