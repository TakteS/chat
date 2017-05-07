defmodule Chat.RoomViewTest do
  use    Chat.ConnCase
  alias  Chat.RoomView
  import Chat.Factory
  import Phoenix.HTML, only: [safe_to_string: 1]

  describe "message_tag/2" do
    setup do
      user = insert(:user)
      conn = auth_conn(user)

      {:ok, user: user, conn: conn}
    end

    test "when user is message author", ctx do
      message = insert(:message, user: ctx.user)
      result  = RoomView.message_tag(ctx.conn, message) |> safe_to_string()

      assert result == message_tag(message, "own-message")
    end

    test "when user is not message author", ctx do
      message = insert(:message)
      result  = RoomView.message_tag(ctx.conn, message) |> safe_to_string()

      assert result == message_tag(message, "message")
    end
  end

  defp message_tag(message, "own-message"),
    do: ~s(<div class="own-message"><b>You say: </b>#{message.body}</div>)

  defp message_tag(message, "message"),
    do: ~s(<div class="message"><b>#{message.user.username} say: </b>#{message.body}</div>)
end
