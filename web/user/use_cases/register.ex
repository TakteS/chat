defmodule Chat.User.UseCase.Register do
  @moduledoc """
  Register an user.
  """

  alias Chat.{User, Repo}
  alias Chat.User.Validator
  alias Chat.Plug.Auth

  @doc """
  Register an user.
  The function takes `conn` and `params` args and return statement is one of:
    * `{:ok, conn, user}` - when user was successfully registered;
    * `{:error, changeset}` - when params are invalid.

  In case when user was successfully registered he also will authenticated.

  ### Example:
      params = %{"username" => "username", "password" => "password"}
      Register.run(conn, params)
  """
  @spec run(Plug.Conn.t, map) :: tuple
  def run(conn, params) do
    params =
      params
      |> cast_hashed_password()
      |> cast_token()

    Validator.changeset(%User{}, params)
    |> Repo.insert
    |> maybe_authenticate(conn)
  end

  defp cast_hashed_password(%{"password" => password} = params) when not(password in ["", nil]),
    do: Map.put(params, "hashed_password", Comeonin.Bcrypt.hashpwsalt(password))
  defp cast_hashed_password(params), do: params

  defp cast_token(params), do: Map.put(params, "token", Ecto.UUID.generate)

  defp maybe_authenticate({:ok, user}, conn), do: {:ok, Auth.login(conn, user), user}
  defp maybe_authenticate(error, _),          do: error
end
