defmodule Chat.RoomController do
  use    Chat.Web, :controller
  alias  Chat.{Repo, Room}
  alias  Chat.Room.Validator
  alias  Chat.Room.UseCase.{Create, Update, Delete}
  import Chat.Plug.Redirects, only: [redirect_unless_authenticated: 2, redirect_unless_admin: 2]

  plug :redirect_unless_authenticated
  plug :redirect_unless_admin when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params, _current_user) do
    rooms = Repo.all(Room)
    render conn, "index.html", rooms: rooms
  end

  def show(conn, %{"id" => id}, _current_user) do
    room = Repo.get!(Room, id)
    render conn, "show.html", room: room
  end

  def new(conn, _params, _current_user) do
    changeset = Validator.changeset(%Room{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"room" => params}, _current_user) do
    case Create.run(params) do
      {:ok, _room}        -> redirect(conn, to: room_path(conn, :index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => id}, _current_user) do
    room      = Repo.get!(Room, id)
    changeset = Validator.changeset(room, %{})

    render conn, "edit.html", changeset: changeset, room: room
  end

  def update(conn, %{"id" => id, "room" => params}, _current_user) do
    room = Repo.get!(Room, id)

    case Update.run(id, params) do
      {:ok, _room}        -> redirect(conn, to: room_path(conn, :index))
      {:error, changeset} -> render conn, "edit.html", changeset: changeset, room: room
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    Delete.run(id)
    redirect(conn, to: room_path(conn, :index))
  end
end
