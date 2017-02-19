defmodule Chat.Plug.AuthTest do
  use    Chat.ConnCase
  alias  Chat.Plug.Auth
  import Chat.Factory

  setup do
    conn = session_conn()
    user = insert(:user)
    {:ok, conn: conn, user: user}
  end

  test "login/2", ctx do
    conn = Auth.login(ctx.conn, ctx.user)
    assert conn.assigns.current_user.id == ctx.user.id
    assert get_session(conn, :user_id)  == ctx.user.id
  end

  test "logout/1", ctx do
    conn = Auth.login(ctx.conn, ctx.user) |> Auth.logout
    refute get_session(conn, :user_id)
  end
end
