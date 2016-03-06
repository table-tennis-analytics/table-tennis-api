class User < ActiveRecord::Base
  GAME_THRESHOLD = 6
  MAGIK = 0.46

  K_FACTORS = {
    6..12 => 28,
    13..25 => 60,
    26..51 => 88,
    52..100 => 116,
    101..200 => 144,
    201..500 => 172,
    500..(1.0 / 0.0) => 200,
  }

  has_many :challenged_games, class_name: 'Game', foreign_key: :challenger_id
  has_many :received_games, class_name: 'Game', foreign_key: :challenged_id
  has_many :won_games, class_name: 'Game', foreign_key: :winner_id

  scope :ordered, -> { order coefficient: :desc, created_at: :asc }
  scope :search, -> query { where 'name ILIKE ?', "%#{ query }%" if query.present? }

  validates :name, presence: true, uniqueness: true

  def recalculate_coeffiecient! opponent
    return if total_games < GAME_THRESHOLD

    _coefficient = if total_games == GAME_THRESHOLD
      wins = total_wins

      opponent_averages = all_games.claimed.sum do |game|
        _opponent = if game.challenger.id == id
          challenged
        else
          challenger
        end

        _opponent.rated_coefficient
      end / GAME_THRESHOLD

      (wins / (wins + total_losses)) * opponent_averages + MAGIK * opponent_averages
    else
      return unless opponent.rated?

      (opponent.coefficient - coefficient + 1000) / k_factor
    end

    update coefficient: _coefficient
  end

  def position
    User.ordered.to_a.index { |u| u.id == id }
  end

  def rated_coefficient
    rated? ? coefficient : 1000
  end

  def rated?
    coefficient != 0
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

  def k_factor
    t = total_games

    K_FACTORS.find do |range, factor|
      range === t
    end.last
  end

end
