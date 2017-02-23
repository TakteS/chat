defmodule Chat.Room.UseCase.Delete do
  @moduledoc """
  Delete a chat room.
  """

  alias Chat.{Repo, Room}

  @doc """
  Delete a chat room.
  Function takes an `id` arg and delete the chat room.
  When room with this `id` is not exists function raises an exception.

  ### Example:
      Delete.run(1)
  """
  @spec run(integer) :: :ok
  def run(id), do: Repo.get!(Room, id) |> Repo.delete!
end
