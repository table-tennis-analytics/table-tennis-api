module V1
  class UsersController < ApplicationController

    def index
      respond_with User.all
    end

    def create
      respond_with User.create(user_params)
    end

    private

    def user_params
      params.require(:user).permit!
    end

  end
end