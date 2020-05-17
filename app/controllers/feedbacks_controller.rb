class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  require 'http'

  ML_API_URI = 'https://generaitor-ml-api.herokuapp.com/summarizer/feedback_sum'

  def create
    token = request.headers['Authorization']

    keywords_tmp = ''
    if params[:feedback][:keywords] != nil
      params[:feedback][:keywords].each do |k|
        keywords_tmp = keywords_tmp + k + ':::'
      end
    end
    params[:feedback][:keywords] = keywords_tmp

    f = current_user.feedbacks.create(feedback_create_params(params))

    feedback_sum = {
      id: 0,
      feedback_ids: '',
      feedback_all: '',
      summary: ''
    }

    if f.id > 0
      new_feedback_data = {
        :feedback => {
          :id => f.id,
          :organization_name => params[:feedback][:organization_name],
          :for_product => params[:feedback][:for_product],
          :product_id => params[:feedback][:product_id],
          :branch_address => params[:feedback][:branch_address],
          :sentiment => params[:feedback][:sentiment],
          :keywords => params[:feedback][:keywords],
          :content => params[:feedback][:content]
        }
      }
  
      response = HTTP.auth(token)
        .post(ML_API_URI, :json => new_feedback_data)
  
      body_payload = response.parse
      fs = body_payload['data']

      if ((response.code == 200 || response.code == 201) && (fs['feedback_all'] != f.content) && (fs['summary'] != ''))
        feedback_sum['id'] = fs['id']
        feedback_sum['feedback_ids'] = fs['feedback_ids']
        feedback_sum['feedback_all'] = fs['feedback_all']
        feedback_sum['summary'] = fs['summary']

        new_fs = FeedbacksSum.new({id: fs['id'], feedback_ids: fs['feedback_ids'], feedback_all: fs['feedback_all'], summary: fs['summary']})
        new_fs.save
      end

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
          },
          feedback_sum: feedback_sum
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
            keywords: '',
            content: '',
            user_id: 0
          },
          feedback_sum: feedback_sum
        }
      }, status: 400
    end
  end


  def mark_red_sum
    profile_type = current_user.accountable_type
    organization = current_user.accountable
    
    token = request.headers['Authorization']
    fs_id = params['id']

    fs = nil
    fs_list = FeedbacksSum.where(id: fs_id)
    if fs_list.length > 0
      fs = fs_list.first
    else
      return render json: {
        data: {
          msg: 'not found'
        }
      }, status: 404
    end

    if profile_type == 'Organization'
      f_id = fs.feedback_ids.split(':::')[0].to_i
      f_list = Feedback.where(id: f_id)
      if f_list.length > 0
        f = f_list.first
        if organization.name == f.organization_name
          fs.red = true
          updated = fs.save

          if updated
            render json: {
              data: {
                msg: 'updated'
              }
            }, status: 200
          else
            render json: {
              data: {
                msg: 'error occured'
              }
            }, status: 400
          end
        else
          render json: {
            data: {
              msg: 'only addressed organizations can modify summaries'
            }
          }, status: 400
        end
      else
        render json: {
          data: {
            msg: 'something weird happened. contact with us, please'
          }
        }, status: 400
      end
    else
      render json: {
        data: {
          msg: 'only addressed organizations can modify summaries'
        }
      }, status: 400
    end

  end


  private
    def feedback_create_params(params)
      params.require(:feedback).permit(:organization_name, :for_product, :product_id, :branch_address, :sentiment, :keywords, :content)
    end
end
