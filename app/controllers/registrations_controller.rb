class RegistrationsController < Devise::RegistrationsController
    private

        def sign_up_params
            
            u = nil
            if params[:user][:accountable_type] == 'Organization'
                u = Organization.create(organization_sign_up_params(params[:user]))
            elsif params[:user][:accountable_type] == 'IdeaGeneraitor'
                u = IdeaGeneraitor.create(idea_generaitor_sign_up_params(params[:user]))
            end

            params[:user][:accountable_id] = u.id
            params[:user][:jti] = SecureRandom.uuid

            params.require(:user).permit(:email, :password, :password_confirmation, :accountable_type, :accountable_id, :jti)
        end

        def organization_sign_up_params(organization_params)
            organization_params.require(:organization).permit(:name, :logo_uri, :description)
        end

        def idea_generaitor_sign_up_params(idea_generaitor_params)
            idea_generaitor_params.require(:idea_generaitor).permit(:full_name, :avatar_uri, :description)
        end

  end