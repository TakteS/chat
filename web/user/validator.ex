defmodule Chat.User.Validator do
  import Ecto.Changeset

  @required_fields [:username, :password, :hashed_password, :role]
  @roles ~w(user admin)

  @spec changeset(Chat.User.t, map) :: Ecto.Changeset.t
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_username()
    |> validate_password()
    |> validate_role()
  end

  defp validate_username(changeset) do
    changeset
    |> validate_length(:username, max: 50)
    |> unique_constraint(:username)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 255)
  end

  defp validate_role(changeset) do
    changeset
    |> validate_inclusion(:role, @roles)
  end
end
