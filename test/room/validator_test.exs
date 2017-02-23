defmodule Chat.Room.ValidatorTest do
  use   Chat.ModelCase
  alias Chat.{Room, TestUtils}
  alias Chat.Room.Validator

  describe "changeset/2" do
    @required_fields [:name]

    test "validate fields presence" do
      message   = {"can't be blank", [validation: :required]}
      changeset = Validator.changeset(%Room{}, %{})

      for field <- @required_fields, do: assert changeset.errors[field] == message
    end

    test "validate name length" do
      message   = {"should be at most %{count} character(s)", [count: 50, validation: :length, max: 50]}
      changeset = Validator.changeset(%Room{}, %{"name" => TestUtils.random_string(51)})
      assert changeset.errors[:name] == message
    end
  end
end
