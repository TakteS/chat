defmodule Chat.Room do
  use Ecto.Schema

  schema "rooms" do
    field :name, :string
  end
end
