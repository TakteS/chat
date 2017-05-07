defmodule Chat.PageControllerTest do
  use Chat.ConnCase

  describe "GET /set-locale" do
    setup do
      conn = build_conn()
      {:ok, conn: conn}
    end

    test "set locale and redirect to path from params", ctx do
      conn = get(ctx.conn, page_path(ctx.conn, :set_locale), %{locale: "ru", redirect_path: "/login"})
      assert redirected_to(conn) == "/login"
      assert get_session(conn, :locale) == "ru"
    end
  end
end
