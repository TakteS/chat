defmodule Chat.Room.UseCase.Create do
  @moduledoc """
  Create a chat room.
  """

  alias Chat.{Repo, Room}
  alias Chat.Room.Validator

  @doc """
  Create a chat room.
  The function takes `params` arg and create new chat room.
  Function result is one of:
    * `{:ok, room}` - when room was successfully created;
    * `{:error, changeset}` - when params are invalid.

  ### Example:
      params = %{"name" => "Room name"}
      Create.run(params)
  """
  @spec run(map) :: tuple
  def run(params) do
    Validator.changeset(%Room{}, params)
    |> Repo.insert
  end
end
