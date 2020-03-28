class ProfilesController < ApplicationController
  # before_action :authenticate_user!

  def show
    
    current_user = nil
    if User.exists?(params[:id])
      current_user = User.find(params[:id])
    end

    if current_user == nil
      render status: :bad_request
    else  
      profile = current_user.accountable

      profile_data = nil
      if current_user.accountable_type == 'Organization'
        profile_data = {
          profile_id: profile.id,
          name: profile.name,
          logo_uri: profile.logo_uri,
          description: profile.description
        }
      elsif current_user.accountable_type == 'IdeaGeneraitor'
        profile_data = {
          profile_id: profile.id,
          full_name: profile.full_name,
          avatar_uri: profile.avatar_uri,
          description: profile.description
        }
      end

      render json: {
        data: {
          user: {
            user_id: current_user.id,
            email: current_user.email,
            profile_type: current_user.accountable_type
          },
          profile: profile_data
        }
      }
    end

  end

end
