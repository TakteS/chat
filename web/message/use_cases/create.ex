defmodule Chat.Message.UseCase.Create do
  @moduledoc """
  Create new chat message in the room.
  """

  alias Chat.{Message, Repo}
  alias Chat.Message.Validator

  @doc """
  Create new chat message in the room.
  The function takes `params`, `user` and `room` args and return statement is one of:
    * `{:ok, message}` - when message was successfully created;
    * `{:error, changeset}` - when params are invalid.

  ### Example:
      user   = Repo.get(User, 1)
      room   = Repo.get(Room, 1)
      params = %{"body" => "Some message"}

      Create.run(params, user, room)
  """
  @spec run(map, Chat.User.t, Chat.Room.t) :: tuple
  def run(params, user, room) do
    params =
      params
      |> Map.put("user_id", user.id)
      |> Map.put("room_id", room.id)

    Validator.changeset(%Message{}, params)
    |> Repo.insert
  end
end
