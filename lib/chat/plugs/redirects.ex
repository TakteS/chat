defmodule Chat.Plug.Redirects do
  @moduledoc """
  Plug with functions for users redirecting.
  """

  use    Phoenix.Controller
  import Chat.Router.Helpers

  @doc """
  Redirect unauthenticated users to login page.

  ### Example:
      Redirects.redirect_unless_authenticated(conn, [])
  """
  @spec redirect_unless_authenticated(Plug.Conn, keyword) :: Plug.Conn.t
  def redirect_unless_authenticated(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      redirect(conn, to: user_path(conn, :login)) |> halt()
    end
  end

  @doc """
  Redirect authenticated users to root path.

  ### Example:
      Redirects.redirect_if_authenticated(conn, [])
  """
  @spec redirect_if_authenticated(Plug.Conn, keyword) :: Plug.Conn.t
  def redirect_if_authenticated(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: "/") |> halt()
    else
      conn
    end
  end
end
