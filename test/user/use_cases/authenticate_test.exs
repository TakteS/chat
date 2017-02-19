defmodule Chat.User.UseCase.AuthenticateTest do
  use    Chat.ConnCase
  alias  Chat.User.UseCase.Authenticate
  import Chat.Factory

  describe "run/2" do
    setup do
      conn = session_conn()
      user = insert(:user)
      {:ok, conn: conn, user: user}
    end

    test "authenticate user when params are valid", ctx do
      params = %{"username" => ctx.user.username, "password" => "password"}
      assert {:ok, conn} = Authenticate.run(ctx.conn, params)
      assert conn.assigns.current_user.id == ctx.user.id
      assert get_session(conn, :user_id)  == ctx.user.id
    end

    test "don't authenticate user when params are invalid", ctx do
      params = %{"username" => ctx.user.username, "password" => "fake password"}
      assert {:error, :invalid_params} = Authenticate.run(ctx.conn, params)
    end
  end
end
