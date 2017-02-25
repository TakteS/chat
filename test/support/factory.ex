defmodule Chat.Factory do
  use ExMachina.Ecto, repo: Chat.Repo

  def user_factory() do
    %Chat.User{
      username:        sequence(:username, &"user#{&1}"),
      hashed_password: Comeonin.Bcrypt.hashpwsalt("password"),
      role:            "user",
      token:           Ecto.UUID.generate
    }
  end

  def room_factory() do
    %Chat.Room{
      name: sequence(:name, &"room-#{&1}")
    }
  end
end
