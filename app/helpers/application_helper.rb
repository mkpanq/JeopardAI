module ApplicationHelper
  def render_turbo_stream_flash_messages(message)
    turbo_stream.update "answer_results_frame",
                        partial: "layouts/answer_result_message",
                        locals: { message: message }
  end
end
