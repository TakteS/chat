defmodule Chat.User.UseCase.RegisterTest do
  use   Chat.ConnCase
  alias Chat.User.UseCase.Register

  setup do
    conn = session_conn()
    {:ok, conn: conn}
  end

  describe "run/2" do
    test "when params are valid", ctx do
      params = %{
        "username" => "someusername",
        "password" => "password"
      }

      assert {:ok, conn, user} = Register.run(ctx.conn, params)
      assert user.username == params["username"]
      assert Comeonin.Bcrypt.checkpw(params["password"], user.hashed_password)

      assert conn.assigns.current_user.id == user.id
      assert get_session(conn, :user_id)  == user.id
    end

    test "when params are invalid", ctx do
      params = %{
        "username" => "",
        "password" => ""
      }

      assert {:error, chageset} = Register.run(ctx.conn, params)
      refute chageset.valid?
    end
  end
end
