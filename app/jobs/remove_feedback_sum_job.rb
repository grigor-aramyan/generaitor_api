class RemoveFeedbackSumJob < ApplicationJob
  queue_as :default

  retry_on RuntimeError

  require 'http'

  def perform(remove_uri, token)
    response = HTTP.auth(token)
      .delete(remove_uri)

    if response.code == 200
      body_payload = response.parse
      deleted_fs_id, res_msg = body_payload['id'], body_payload['msg']
    else
      raise RuntimeError, 'error removing feedback sum'
    end
  end

end
