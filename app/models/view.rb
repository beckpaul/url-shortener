class View < ApplicationRecord
  belongs_to :links, counter_cache: true
end
