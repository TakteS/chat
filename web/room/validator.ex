defmodule Chat.Room.Validator do
  import Ecto.Changeset

  @required_fields [:name]

  @spec changeset(Chat.Room.t, map) :: Ecto.Changeset.t
  def changeset(room, params \\ %{}) do
    room
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_name()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_length(:name, max: 50)
  end
end
