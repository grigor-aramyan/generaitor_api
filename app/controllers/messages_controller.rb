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
    messages_count = 20

    unred_messages_id =
      Message.where(receiver_id: current_user.id, red: false)
      .select(:id)
      .distinct.pluck(:user_id)

    unred_messages =
      Message.where(id: unred_messages_id)
      .order('id DESC')
      .limit(messages_count)

    if unred_messages.length == messages_count
      render json: {
        data: {
          messages: unred_messages
        }
      }, status: 200
    else
      remained_messages_count = messages_count - unred_messages.length

      remained_messages_ids =
        Message.where(receiver_id: current_user.id)
        .select(:id)
        .distinct.pluck(:user_id)
        
      filtered_remained_messages_ids = []
      remained_messages_ids.each do |i|
        if unred_messages_id.include?(i)
          next
        else
          filtered_remained_messages_ids.push(i)
        end
      end

      remained_messages =
        Message.where(id: filtered_remained_messages_ids)
        .order('id DESC')
        .limit(remained_messages_count)

      all_messages = unred_messages + remained_messages

      render json: {
        data: {
          messages: all_messages
        }
      }, status: 200
    end

  end

  def mark_red
  end

  private
    def message_create_params(params)
      params.require(:message).permit(:content, :receiver_id, :user_id)
    end
end
