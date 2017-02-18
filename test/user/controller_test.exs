defmodule Chat.UserControllerTest do
  use Chat.ConnCase

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  describe "GET /register" do
    test "renders :new template", ctx do
      conn = get(ctx.conn, user_path(ctx.conn, :new))
      assert html_response(conn, 200)
      assert render_template(conn) == "new.html"
    end
  end

  describe "PUT /register" do
    test "renders :new template when params are invalid", ctx do
      conn = put(ctx.conn, user_path(ctx.conn, :create), %{"user" => %{}})
      assert html_response(conn, 200)
      assert render_template(conn) == "new.html"
    end

    test "redirect to root path when params are valid", ctx do
      params = %{
        "user" => %{
          "username" => "username",
          "password" => "password"
        }
      }

      conn = put(ctx.conn, user_path(ctx.conn, :create), params)
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end
end
