class UsersController < ApplicationController
    before_action :check_token # Order
    prepend_before_action :authenticate_user!
    append_before_action :set_response_header
    def show
        outs = { email: current_user.email,full_name: current_user.full_name, image_url: current_user.image_url}
        render json: outs, status: :ok
    end
end
