defmodule Chat.Room.UseCase.DeleteTest do
  use    Chat.ModelCase
  alias  Chat.{Repo, Room}
  alias  Chat.Room.UseCase.Delete
  import Chat.Factory

  describe "run/1" do
    setup do
      room = insert(:room)
      {:ok, room: room}
    end

    test "delete the room when exists", ctx do
      assert %Room{} = Delete.run(ctx.room.id)
      refute Repo.get(Room, ctx.room.id)
    end

    test "raise an error when room is not exists" do
      assert_raise Ecto.NoResultsError, fn -> Delete.run(-1) end
    end
  end
end
