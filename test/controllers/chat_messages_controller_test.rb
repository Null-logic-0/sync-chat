require "test_helper"

class ChatMessagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:three)
    @other_user = users(:two)
    @chat = Chat.find_by(sender: @user, recipient: @other_user) ||
            Chat.find_by(sender: @other_user, recipient: @user) ||
            Chat.create!(sender: @user, recipient: @other_user)
    log_in_as(@user)
  end

  test "should create chat message" do
    assert_difference("@chat.chat_messages.count", 1) do
      post chat_chat_messages_path(@chat),
           params: { chat_message: { content: "Hello!" } },
           headers: { "HTTP_ACCEPT" => "text/vnd.turbo-stream.html" }
    end

    assert_response :success

    assert_equal "Hello!", @chat.chat_messages.last&.content
    assert_equal @user.id, @chat.chat_messages.last&.user_id
  end
end
