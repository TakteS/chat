defmodule Chat.Room.UseCase.CreateTest do
  use    Chat.ModelCase
  alias  Chat.Room.UseCase.Create

  describe "run/1" do
    test "when params are valid" do
      params = %{"name" => "Room name"}
      assert {:ok, room} = Create.run(params)
      assert room.name == params["name"]
    end

    test "when params are invalid" do
      params = %{"name" => ""}
      assert {:error, changeset} = Create.run(params)
      refute changeset.valid?
    end
  end
end
