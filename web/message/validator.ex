defmodule Chat.Message.Validator do
  @moduledoc """
  Message validator.
  """

  import Ecto.Changeset

  @requred_fields [:body, :user_id, :room_id]

  @spec changeset(Chat.Message.t, map) :: Ecto.Changeset.t
  def changeset(message, params \\ %{}) do
    message
    |> cast(params, @requred_fields)
    |> validate_required(@requred_fields)
    |> validate_body()
  end

  defp validate_body(changeset) do
    changeset
    |> validate_length(:body, max: 100)
  end
end
