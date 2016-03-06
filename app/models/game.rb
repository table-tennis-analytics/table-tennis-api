class Game < ActiveRecord::Base
  belongs_to :challenger, class_name: 'User'
  belongs_to :challenged, class_name: 'User'
  belongs_to :winner, class_name: 'User'

  scope :claimed, -> { where.not challenger_id: nil, challenged_id: nil }
  scope :unclaimed, -> { where challenger_id: nil, challenged_id: nil }
  scope :ordered, -> { order updated_at: :desc }

  after_update :recalculate_coefficients!, if: :winner_id_changed?

  def challenger_id= _id
    super
    self.winner_id = _id
  end

  private

  def recalculate_coefficients!
    challenger.recalculate_coefficient! challenged
    challenged.recalculate_coefficient! challenger
  end

end
