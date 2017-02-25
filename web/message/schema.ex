defmodule Chat.Message do
  use Ecto.Schema

  schema "messages" do
    belongs_to :user, Chat.User
    belongs_to :room, Chat.Room

    field :body, :string
    timestamps()
  end
end
