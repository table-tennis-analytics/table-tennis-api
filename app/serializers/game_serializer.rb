class GameSerializer < ActiveModel::Serializer
  attributes :id, :challenger_score, :challenged_score

  has_one :challenger
  has_one :challenged
  has_one :winner
end
