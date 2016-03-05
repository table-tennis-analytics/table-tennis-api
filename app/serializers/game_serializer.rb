class GameSerializer < ActiveModel::Serializer
  attributes :id, :challenger_score, :challenged_score

  has_one :challenger, serializer: GameUserSerializer
  has_one :challenged, serializer: GameUserSerializer
  has_one :winner, serializer: GameUserSerializer
end
