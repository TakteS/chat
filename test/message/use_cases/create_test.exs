defmodule Chat.Message.UseCase.CreateTest do
  use    Chat.ModelCase
  alias  Chat.Message.UseCase.Create
  import Chat.Factory

  describe "run/3" do
    setup do
      user = insert(:user)
      room = insert(:room)
      {:ok, user: user, room: room}
    end

    test "when params are valid", ctx do
      params = %{"body" => "Message body"}
      assert {:ok, message}  =  Create.run(params, ctx.user, ctx.room)
      assert message.body    == params["body"]
      assert message.user_id == ctx.user.id
      assert message.room_id == ctx.room.id
      assert message.inserted_at
    end

    test "when params are invalid", ctx do
      params = %{"body" => ""}
      assert {:error, changeset} = Create.run(params, ctx.user, ctx.room)
      refute changeset.valid?
    end
  end
end
