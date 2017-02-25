defmodule Chat.Message.ValidatorTest do
  use   Chat.ModelCase
  alias Chat.{Message, TestUtils}
  alias Chat.Message.Validator

  describe "changeset/2" do
    @required_fields [:body, :user_id, :room_id]

    test "validate fields presence" do
      message   = {"can't be blank", [validation: :required]}
      changeset = Validator.changeset(%Message{}, %{})

      for field <- @required_fields, do: assert changeset.errors[field] == message
    end

    test "validate body length" do
      message   = {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]}
      changeset = Validator.changeset(%Message{}, %{body: TestUtils.random_string(101)})
      assert changeset.errors[:body] == message
    end
  end
end
