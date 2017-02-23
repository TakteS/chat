defmodule Chat.Room.UseCase.Update do
  @moduledoc """
  Update a chat room.
  """

  alias Chat.{Repo, Room}
  alias Chat.Room.Validator

  @doc """
  Update a chat room.
  The function takes `room_id` and `params` args and update the chat room.
  Function result is one of:
    * `{:ok, room}` - when room was successfully updated;
    * `{:error, changeset}` - when params are invalid.

  When room with this `id` is not exists function raises an exception.

  ### Example:
      params = %{"name" => "Room name"}
      Update.run(1, params)
  """
  @spec run(integer, map) :: tuple
  def run(id, params) do
    Repo.get!(Room, id)
    |> Validator.changeset(params)
    |> Repo.update
  end
end
