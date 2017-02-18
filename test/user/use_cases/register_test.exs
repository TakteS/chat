defmodule Chat.User.UseCase.RegisterTest do
  use   Chat.ModelCase
  alias Chat.User.UseCase.Register

  describe "run/1" do
    test "when params are valid" do
      params = %{
        "username" => "someusername",
        "password" => "password"
      }

      assert {:ok, user}   =  Register.run(params)
      assert user.username == params["username"]
      assert Comeonin.Bcrypt.checkpw(params["password"], user.hashed_password)
    end

    test "when params are invalid" do
      params = %{
        "username" => "",
        "password" => ""
      }

      assert {:error, chageset} = Register.run(params)
      refute chageset.valid?
    end
  end
end
