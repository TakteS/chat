defmodule Chat.User do
  use Ecto.Schema

  schema "users" do
    field :username,        :string
    field :hashed_password, :string
    field :password,        :string, virtual: true
    field :role,            :string, default: "user"
    field :token,           :string
  end
end
