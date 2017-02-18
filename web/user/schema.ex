defmodule Chat.User do
  use Ecto.Schema

  schema "users" do
    field :username,        :string
    field :hashed_password, :string
    field :password,        :string, virtual: true
  end
end
