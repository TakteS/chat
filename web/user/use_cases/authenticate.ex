defmodule Chat.User.UseCase.Authenticate do
  @moduledoc """
  Authenticate an user.
  """

  alias Chat.{Repo, User}
  alias Chat.Plug.Auth

  @doc """
  Authenticate an user.
  The function takes `conn` and `params` args and return statement is one of:
    * `{:ok, conn}` - when user was successfully authenticated;
    * `{:error, :invalid_params}` - when params are invalid.

  ### Example:
      params = %{"username" => "username", "password" => "password"}
      Authenticate.run(conn, params)
  """
  @spec run(Plug.Conn.t, map) :: tuple
  def run(conn, params) do
    Repo.get_by(User, username: params["username"])
    |> maybe_authenticate(params, conn)
  end

  defp maybe_authenticate(nil, _, _), do: error_response()
  defp maybe_authenticate(user, params, conn) do
    if Comeonin.Bcrypt.checkpw(params["password"], user.hashed_password) do
      {:ok, Auth.login(conn, user)}
    else
      error_response()
    end
  end

  defp error_response(), do: {:error, :invalid_params}
end
