module V1
  class GamesController < ApplicationController

    def index
      respond_with Game.ordered.send(params[:scope])
    end

    def create
      respond_with Game.create(game_params), location: nil
    end

    def update
      game.update game_params

      head :no_content
    end

    private

    def game
      game ||= Game.find params[:id]
    end

    def game_params
      params.require(:game).permit!
    end

  end
end