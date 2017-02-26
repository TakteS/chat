defmodule Chat.Room do
  use Ecto.Schema

  schema "rooms" do
    has_many :messages, Chat.Message, on_delete: :delete_all
    field :name, :string
  end
end
