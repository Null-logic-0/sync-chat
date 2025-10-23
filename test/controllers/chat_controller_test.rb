require "test_helper"

class ChatControllerTest < ActionDispatch::IntegrationTest
  def setup
    @sender = users(:one)
    @recipient = users(:two)
    log_in_as(@sender)
  end

  test "should start chat and render turbo stream" do
    post start_chats_path, params: { recipient_id: @recipient.id }, headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_match "turbo-stream", @response.body

    chat = Chat.find_by(sender: @sender, recipient: @recipient) ||
           Chat.find_by(sender: @recipient, recipient: @sender)
    assert_not_nil chat, "Chat should be created or found"
    assert_equal chat.id, assigns(:selected_chat).id
    assert_equal [], assigns(:chat_messages) if chat.chat_messages.empty?
  end
end
