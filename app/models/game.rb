class Game < ActiveRecord::Base
  belongs_to :challenger, class_name: 'User'
  belongs_to :challenged, class_name: 'User'
  belongs_to :winner, class_name: 'User'

  after_update :recalculate_coefficients!, if: :winner_id_changed?

  private

  def recalculate_coefficients!
    [challenger, challenged].each(&:recalculate_coefficient!)
  end

end
