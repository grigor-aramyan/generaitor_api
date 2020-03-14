class SessionsController < Devise::SessionsController
    include ActionController::MimeResponds

    skip_before_action :verify_signed_out_user, only: :destroy

    def destroy
        render status: :ok
    end
end