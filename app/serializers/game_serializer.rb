class GameSerializer < ActiveModel::Serializer
  attributes :id, :challenger_score, :challenged_score, :time

  has_one :challenger, serializer: GameUserSerializer
  has_one :challenged, serializer: GameUserSerializer
  has_one :winner, serializer: GameUserSerializer

  def time
    object.created_at.strftime('%H:%M')
  end
end
