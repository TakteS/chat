defmodule Chat.UserController do
  use    Chat.Web, :controller
  alias  Chat.User
  alias  Chat.Plug.Auth
  alias  Chat.User.Validator
  alias  Chat.User.UseCase.{Register, Authenticate}
  import Chat.Plug.Redirects, only: [redirect_if_authenticated: 2]

  plug :redirect_if_authenticated when not(action in [:logout])

  def new(conn, _params, _curent_user) do
    changeset = Validator.changeset(%User{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => params}, _current_user) do
    case Register.run(conn, params) do
      {:ok, conn, _user} ->
        conn
        |> redirect(to: "/")
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def login(conn, _params, _curent_user), do: render conn, "login.html"

  def do_login(conn, %{"user" => params}, _current_user) do
    case Authenticate.run(conn, params) do
      {:ok, conn}       -> redirect(conn, to: "/")
      {:error, _reason} -> render conn, "login.html"
    end
  end

  def logout(conn, _params, _current_user) do
    conn = Auth.logout(conn)
    redirect(conn, to: user_path(conn, :login))
  end
end
