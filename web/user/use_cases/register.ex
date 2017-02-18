defmodule Chat.User.UseCase.Register do
  alias Chat.{User, Repo}
  alias Chat.User.Validator


  def run(params) do
    params = cast_hashed_password(params)

    Validator.changeset(%User{}, params)
    |> Repo.insert
  end

  defp cast_hashed_password(%{"password" => password} = params) when not(password in ["", nil]),
    do: Map.put(params, "hashed_password", Comeonin.Bcrypt.hashpwsalt(password))
  defp cast_hashed_password(params), do: params
end
