defmodule Chat.RoomChannel do
  use   Phoenix.Channel
  alias Chat.{Repo, Room, User}
  alias Chat.Message.UseCase.Create

  def join("room:" <> room_id, _message, socket) do
    if authorize(room_id), do: {:ok, socket}, else: {:error, %{reason: "room is not exists"}}
  end

  def handle_in("join_room:" <> room_id, %{"token" => token}, socket) do
    broadcast! socket, "join_room:#{room_id}", %{username: username(token)}
    {:noreply, socket}
  end

  def handle_in("new_message:" <> room_id , %{"message" => message, "token" => token}, socket) do
    user = Repo.get_by(User, token: token)
    room = Repo.get(Room, room_id)

    case Create.run(%{"body" => message}, user, room) do
      {:ok, message} ->
        broadcast! socket, "new_message:#{room_id}", %{message: message.body, username: user.username}
      {:error, _changeset} ->
        {:error, "invalid message!"}
    end

    {:noreply, socket}
  end

  defp authorize(room_id), do: Repo.get(Room, room_id)

  defp username(token), do: Repo.get_by(User, token: token).username
end
