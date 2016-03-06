class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :total_games, :total_points_scored, :total_points_lost, :total_wins, :total_losses, :coefficient, :position

  def include_position?
    object.rated?
  end

end
