class IdeasController < ApplicationController
  before_action :authenticate_user!

  def create
    profile_type = current_user.accountable_type

    if profile_type != 'IdeaGeneraitor'
      render json: {
        data: {
          msg: 'Only idea generators can post an idea'
        }
      }, status: 400
    else
      idea_generaitor = current_user.accountable

      keywords_tmp = ''
      if params[:idea][:keywords] != nil
        params[:idea][:keywords].each do |k|
          keywords_tmp = keywords_tmp + k.to_s + ':::'
        end
      end
      params[:idea][:keywords] = keywords_tmp

      new_idea = idea_generaitor.ideas.create(idea_create_params(params))
      if new_idea.id > 0
        render json: {
          data: {
            msg: 'Idea created!'
          }
        }, status: 201
      else
        render json: {
          data: {
            msg: 'Idea not created! Try one more time or contact with us, please'
          }
        }, status: 400
      end
    end

  end

  private
    def idea_create_params(params)
      params.require(:idea).permit(:field_or_organization, :idea_description, :keywords, :idea_generaitor_id)
    end
end
