class User < ActiveRecord::Base
  has_many :challenged_games, class_name: 'Game', foreign_key: :challenger_id
  has_many :received_games, class_name: 'Game', foreign_key: :challenged_id
  has_many :won_games, class_name: 'Game', foreign_key: :winner_id

  scope :ordered, -> { order coefficient: :desc }

  def recalculate_coeffiecient!
    update coefficient: total_wins / [1, total_losses].max
  end

  def lost_games
    all_games.where.not(winner_id: nil).where.not(winner_id: id)
  end

  def all_games
    Game.where('id IN (?) OR id IN (?)', challenged_games.select(:id), received_games.select(:id)).uniq
  end

  def total_games
    all_games.size
  end

  def total_points_scored
    challenged_games.sum(:challenger_score) + received_games.sum(:challenged_score)
  end

  def total_points_lost
    challenged_games.sum(:challenged_score) + received_games.sum(:challenger_score)
  end

  def total_wins
    won_games.size
  end

  def total_losses
    lost_games.size
  end

end
