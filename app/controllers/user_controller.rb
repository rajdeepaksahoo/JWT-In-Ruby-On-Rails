class UserController < ApplicationController
  include Authenticatable

  def index
    render json: {message: "Welcome to The World Of Rails"}, status: :ok
  end
end
