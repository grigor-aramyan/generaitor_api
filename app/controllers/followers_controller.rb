class FollowersController < ApplicationController
  before_action :authenticate_user!

  def create
    params[:follower][:followed_by_id] = current_user.id

    if Follower.where(follower_of_id: params[:follower][:follower_of_id], followed_by_id: params[:follower][:followed_by_id]).length > 0
      render json: {
        data: {
          msg: 'Already following'
        }
      }, status: 400
    else
      new_follower = Follower.create(follower_create_params(params))

      if new_follower.id > 0
        render json: {
          data: {
            msg: 'Following'
          }
        }, status: 201
      else
        render json: {
          data: {
            msg: 'Something wrong happened! Contact with us, please'
          }
        }, status: 400
      end
    end
  
  end

  private
    def follower_create_params(params)
      params.require(:follower).permit(:follower_of_id, :followed_by_id)
    end
end
