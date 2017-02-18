defmodule Chat.User.ValidatorTest do
  use   Chat.ModelCase
  alias Chat.{User, TestUtils}
  alias Chat.User.Validator

  describe "changeset/2" do
    @reqired_fields [:username, :password, :hashed_password]

    test "validate fields presence" do
      message   = {"can't be blank", [validation: :required]}
      changeset = Validator.changeset(%User{}, %{})

      for field <- @reqired_fields, do: assert changeset.errors[field] == message
    end

    test "validate username length" do
      message   = {"should be at most %{count} character(s)", [count: 50, validation: :length, max: 50]}
      changeset = Validator.changeset(%User{}, %{"username" => TestUtils.random_string(51)})
      assert changeset.errors[:username] == message
    end

    test "validate username uniqueness" do
      message   = {"has already been taken", []}
      params    = %{"username" => "username", "password" => "password", "hashed_password" => "password"}
      changeset = Validator.changeset(%User{}, params)
      assert {:ok, _} = Repo.insert(changeset)

      changeset = Validator.changeset(%User{}, params)
      assert {:error, changeset} = Repo.insert(changeset)
      assert changeset.errors[:username] == message
    end

    test "validate password length" do
      message   = {"should be at most %{count} character(s)", [count: 255, validation: :length, max: 255]}
      changeset = Validator.changeset(%User{}, %{"password" => TestUtils.random_string(256)})
      assert changeset.errors[:password] == message

      message   = {"should be at least %{count} character(s)", [count: 8, validation: :length, min: 8]}
      changeset = Validator.changeset(%User{}, %{"password" => TestUtils.random_string(7)})
      assert changeset.errors[:password] == message
    end
  end
end
