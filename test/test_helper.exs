ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Chat.Repo, :manual)

defmodule Chat.TestUtils do
  def random_string(length), do: 1..length |> Enum.join
end
