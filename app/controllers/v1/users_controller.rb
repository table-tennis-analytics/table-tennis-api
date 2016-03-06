module V1
  class UsersController < ApplicationController

    def index
      respond_with User.ordered
    end

    def show
      respond_with user
    end

    def create
      respond_with User.find_or_create_by(user_params), location: nil
    end

    private

    def user
      @user ||= User.find params[:id]
    end

    def user_params
      params.require(:user).permit!
    end

  end
end