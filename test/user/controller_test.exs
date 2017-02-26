defmodule Chat.UserControllerTest do
  use    Chat.ConnCase
  import Chat.Factory

  setup do
    conn = build_conn()
    user = insert(:user)
    {:ok, conn: conn, user: user}
  end

  describe "GET /register" do
    test "renders :new template when user is not authenticated", ctx do
      conn = get(ctx.conn, user_path(ctx.conn, :new))
      assert html_response(conn, 200)
      assert render_template(conn) == "new.html"
    end

    test "redirect to root path when user is already authenticated", ctx do
      conn = auth_conn(ctx.user)
      conn = get(conn, user_path(conn, :new))
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
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
      assert get_session(conn, :user_id)
    end

    test "redirect to root path when user is already authenticated", ctx do
      conn = auth_conn(ctx.user)
      conn = put(conn, user_path(conn, :create), %{"user" => %{}})
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
      refute get_session(conn, :user_id)
    end
  end

  describe "GET /login" do
    test "renders :login template when user is not authenticated", ctx do
      conn = get(ctx.conn, user_path(ctx.conn, :login))
      assert html_response(conn, 200)
      assert render_template(conn) == "login.html"
    end

    test "redirect to root path when user is already authenticated", ctx do
      conn = auth_conn(ctx.user)
      conn = get(conn, user_path(conn, :login))
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /login" do
    test "authenticate and redirect to root path when params are valid and user is not authenticated", ctx do
      params = %{
        "user" => %{
          "username" => ctx.user.username,
          "password" => "password"
        }
      }

      conn = post(ctx.conn, user_path(ctx.conn, :do_login), params)
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
      assert get_session(conn, :user_id)
    end

    test "don't authenticate and renders :login template when params are invalid", ctx do
      params = %{
        "user" => %{
          "username" => ctx.user.username,
          "password" => "fake password"
        }
      }

      conn = post(ctx.conn, user_path(ctx.conn, :do_login), params)
      assert html_response(conn, 200)
      assert render_template(conn) == "login.html"
      refute get_session(conn, :user_id)
    end

    test "redirect to root path when params are valid and user is already authenticated", ctx do
      params = %{
        "user" => %{
          "username" => ctx.user.username,
          "password" => "password"
        }
      }

      conn = auth_conn(ctx.user)
      conn = post(conn, user_path(conn, :do_login), params)
      assert html_response(conn, 302)
      assert redirected_to(conn) == "/"
    end
  end

  describe "GET /logout" do
    test "redirect to root path", ctx do
      conn = auth_conn(ctx.user)
      conn = get(conn, user_path(conn, :logout))
      assert html_response(conn, 302)
      assert redirected_to(conn) == user_path(conn, :login)
    end
  end
end
