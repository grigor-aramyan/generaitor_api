class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    m = current_user.messages.create(message_create_params(params))

    if m.id > 0
      render json: {
        data: {
          message: {
            id: m.id,
            content: m.content,
            author: m.user_id,
            receiver_id: m.receiver_id,
            created_at: m.created_at
          }
        }
      }, status: 201
    else
      render json: {
        data: {
          message: {
            id: 0,
            content: '',
            author: 0,
            receiver_id: 0,
            created_at: ''
          }
        }
      }, status: 400
    end
  end

  def list
  end

  def mark_red
  end

  private
    def message_create_params(params)
      params.require(:message).permit(:content, :receiver_id, :user_id)
    end
end
