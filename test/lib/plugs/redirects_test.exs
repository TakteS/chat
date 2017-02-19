defmodule Chat.Plug.RedirectsTest do
  use    Chat.ConnCase
  alias  Chat.Plug.Redirects
  import Chat.Factory

  setup do
    user = insert(:user)
    {:ok, user: user}
  end

  describe "redirect_unless_authenticated/2" do
    test "do redirect when user is not authenticated" do
      conn = build_conn() |> Redirects.redirect_unless_authenticated([])
      assert redirected_to(conn) == user_path(conn, :login)
    end

    test "do not redirect when user is authenticated", ctx do
      conn = auth_conn(ctx.user) |> get("/") |> Redirects.redirect_unless_authenticated([])
      assert html_response(conn, 200)
    end
  end

  describe "redirect_if_authenticated/2" do
    test "do not redirect when user is not authenticated" do
      conn = build_conn() |> get("/") |> Redirects.redirect_if_authenticated([])
      assert html_response(conn, 200)
    end

    test "do redirect when user is authenticated", ctx do
      conn = auth_conn(ctx.user) |> Redirects.redirect_if_authenticated([])
      assert redirected_to(conn) == "/"
    end
  end
end
