defmodule Chat.Plug.Auth do
  @moduledoc """
  Plug for users authentication.
  """

  import Plug.Conn

  def init(opts), do: Keyword.fetch!(opts, :repo)

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = user_id && repo.get(Chat.User, user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end


  @doc """
  Create user session.
  The function takes `conn` and `user` params and make `user` authenticated
  (assign `:current_user` variable to `conn` and put `:user_id` session).

  ### Example:
      user = Repo.get(User, 1)
      Auth.login(conn, user)
  """
  @spec login(Plug.Conn.t, Chat.User.t) :: Plug.Conn.t
  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  @doc """
  Delete user session.
  The function takes `conn` param and delete `:user_id` session.

  ### Example:
      Auth.logout(conn)
  """
  @spec logout(Plug.Conn.t) :: Plug.Conn.t
  def logout(conn), do: delete_session(conn, :user_id)
end
