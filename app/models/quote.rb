# frozen_string_literal: true

class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }
  after_create_commit lambda {
                        broadcast_prepend_to 'quotes', partial: 'quotes/quote', locals: { quote: self },
                                                       target: 'quotes'
                      }
  after_create_commit -> { broadcast_prepend_to 'quotes' }
  after_update_commit -> { broadcast_replace_to 'quotes' }
  after_destroy_commit -> { broadcast_remove_to 'quotes' }
  belongs_to :company
  broadcasts_to ->(quote) { [quote.company, 'quotes'] }, inserts_by: :prepend
  has_many :line_item_dates, dependent: :destroy
end
