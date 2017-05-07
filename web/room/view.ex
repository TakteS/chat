defmodule Chat.RoomView do
  use    Chat.Web, :view
  use    Phoenix.View, root: "web/room", path: "templates"
  alias  Chat.Message
  import Chat.LayoutView, only: [user_is_admin: 1]

  @doc """
  Render message tag.
  Function takes `conn`, `message` args and return formatted message.
  When current user is message owner message will returns with `.own-message` class.
  When user is not owner message returns with `.message` class.

  ### Example:
      message = Repo.get(Message, 1)
      RoomView.message_tag(conn, message)
  """
  @spec message_tag(Plug.Conn.t, Message.t) :: Phoenix.HTML.safe
  def message_tag(conn, message) do
    if conn.assigns[:current_user].id == message.user_id do
      content_tag(:div, own_message_tag(message), class: "own-message")
    else
      content_tag(:div, message_tag(message), class: "message")
    end
  end

  @doc "Show count of online users for the `room`"
  @spec online_count(Room.t) :: integer
  def online_count(room) do
    Chat.Presence.list(%Phoenix.Socket{topic: "room:#{room.id}"})
    |> Map.keys()
    |> Enum.count()
  end

  defp own_message_tag(message),
    do: [content_tag(:b, gettext("You say") <> ": "), message.body]

  defp message_tag(message),
    do: [content_tag(:b, "#{message.user.username} " <> gettext("say") <> ": "), message.body]
end
