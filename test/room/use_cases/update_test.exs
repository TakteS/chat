defmodule Chat.Room.UseCase.UpdateTest do
  use    Chat.ModelCase
  alias  Chat.Room.UseCase.Update
  import Chat.Factory

  describe "run/2" do
    setup do
      room = insert(:room, name: "Room name")
      {:ok, room: room}
    end

    test "when params are valid", ctx do
      params = %{"name" => "New room name"}
      assert {:ok, room} = Update.run(ctx.room.id, params)
      assert room.name == params["name"]
    end

    test "when params are invalid", ctx do
      params = %{"name" => ""}
      assert {:error, changeset} = Update.run(ctx.room.id, params)
      refute changeset.valid?
    end

    test "when room is not exists" do
      params = %{"name" => ""}
      assert_raise Ecto.NoResultsError, fn -> Update.run(-1, params) end
    end
  end
end
