defmodule Chat.RoomControllerTest do
  use    Chat.ConnCase
  import Chat.Factory

  setup do
    user = insert(:user, role: "admin")
    conn = auth_conn(user)
    room = insert(:room)

    {:ok, conn: conn, room: room}
  end

  describe "GET /rooms" do
    test "renders :index template when user is authenticated", ctx do
      conn = get(ctx.conn, room_path(ctx.conn, :index))
      assert html_response(conn, 200)
      assert render_template(conn) == "index.html"
    end

    test "redirect to /login path when user is not authenticated" do
      conn = build_conn()
      conn = get(conn, room_path(conn, :index))
      assert html_response(conn, 302)
      assert redirected_to(conn) == user_path(conn, :login)
    end
  end

  describe "GET /rooms/:id" do
    test "renders :show template when user is authenticated", ctx do
      conn = get(ctx.conn, room_path(ctx.conn, :show, ctx.room.id))
      assert html_response(conn, 200)
      assert render_template(conn) == "show.html"
    end

    test "rendirect to /login path when user is not authenticated", ctx do
      conn = build_conn()
      conn = get(conn, room_path(conn, :show, ctx.room.id))
      assert html_response(conn, 302)
      assert redirected_to(conn) == user_path(conn, :login)
    end
  end

  describe "GET /rooms/new" do
    test "renders :new template when user is admin", ctx do
      conn = get(ctx.conn, room_path(ctx.conn, :new))
      assert html_response(conn, 200)
      assert render_template(conn) == "new.html"
    end

    test "redirect to root path when user is not admin" do
      user = insert(:user)
      conn = auth_conn(user)
      conn = get(conn, room_path(conn, :new))
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end

  describe "PUT /rooms" do
    test "redirect to /rooms path when user is admin and params are valid", ctx do
      params = %{"room" => %{"name" => "Room name"}}
      conn   = post(ctx.conn, room_path(ctx.conn, :create), params)
      assert html_response(conn, 302)
      assert redirected_to(conn) == room_path(conn, :index)
    end

    test "renders :new tempate when user is admin and params are invalid", ctx do
      params = %{"room" => %{"name" => ""}}
      conn   = post(ctx.conn, room_path(ctx.conn, :create), params)
      assert html_response(conn, 200)
      assert render_template(conn) == "new.html"
    end

    test "redirect to root path when user is not admin" do
      params = %{"room" => %{"name" => "Room name"}}
      user   = insert(:user)
      conn   = auth_conn(user)
      conn   = post(conn, room_path(conn, :create), params)
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end

  describe "GET /rooms/:id/edit" do
    test "renders :edit template when user is admin", ctx do
      conn = get(ctx.conn, room_path(ctx.conn, :edit, ctx.room.id))
      assert html_response(conn, 200)
      assert render_template(conn) == "edit.html"
    end

    test "redirect to root path when user is not admin", ctx do
      user = insert(:user)
      conn = auth_conn(user)
      conn = get(conn, room_path(conn, :edit, ctx.room.id))
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /rooms/:id" do
    test "redirect to /rooms path when user is admin and params are valid", ctx do
      params = %{"room" => %{"name" => "New room name"}}
      conn   = put(ctx.conn, room_path(ctx.conn, :update, ctx.room.id), params)
      assert html_response(conn, 302)
      assert redirected_to(conn) == room_path(conn, :index)
    end

    test "renders :edit tempate when user is admin and params are invalid", ctx do
      params = %{"room" => %{"name" => ""}}
      conn   = put(ctx.conn, room_path(ctx.conn, :update, ctx.room.id), params)
      assert html_response(conn, 200)
      assert render_template(conn) == "edit.html"
    end

    test "redirect to root path when user is not admin", ctx do
      params = %{"room" => %{"name" => "New room name"}}
      user   = insert(:user)
      conn   = auth_conn(user)
      conn   = put(conn, room_path(conn, :update, ctx.room.id), params)
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end

  describe "DELETE /rooms/:id" do
    test "redirect to /rooms path when user is admin", ctx do
      conn = delete(ctx.conn, room_path(ctx.conn, :delete, ctx.room.id))
      assert html_response(conn, 302)
      assert redirected_to(conn) == room_path(conn, :index)
    end

    test "redirect to root path when user is not admin", ctx do
      user = insert(:user)
      conn = auth_conn(user)
      conn = delete(conn, room_path(conn, :delete, ctx.room.id))
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end
end
