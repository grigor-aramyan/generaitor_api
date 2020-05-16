class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def create
    keywords_tmp = ''
    if params[:feedback][:keywords] != nil
      params[:feedback][:keywords].each do |k|
        keywords_tmp = keywords_tmp + k + ':::'
      end
    end
    params[:feedback][:keywords] = keywords_tmp

    f = current_user.feedbacks.create(feedback_create_params(params))

    if f.id > 0
      render json: {
        data: {
          feedback: {
            id: f.id,
            organization_name: f.organization_name,
            for_product: f.for_product,
            product_id: f.product_id,
            branch_address: f.branch_address,
            sentiment: f.sentiment,
            keywords: f.keywords,
            content: f.content,
            user_id: f.user_id
          }
        }
      }, status: 201
    else
      render json: {
        data: {
          feedback: {
            id: 0,
            organization_name: '',
            for_product: false,
            product_id: 0,
            branch_address: '',
            sentiment: 0,
            keywords: 0,
            content: '',
            user_id: 0
          }
        }
      }, status: 400
    end
  end

  private
    def feedback_create_params(params) do
      params.require(:feedback).permit(:organization_name, :for_product, :product_id, :branch_address, :sentiment, :keywords, :content)
    end
end
