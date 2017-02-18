defmodule Chat.UserController do
  use   Chat.Web, :controller
  alias Chat.User
  alias Chat.User.Validator
  alias Chat.User.UseCase.Register

  def new(conn, _params) do
    changeset = Validator.changeset(%User{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => params}) do
    case Register.run(params) do
      {:ok, _user} ->
        conn
        |> redirect(to: "/")
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
