defmodule Chat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username,        :string, null: false, default: ""
      add :hashed_password, :string, null: false, default: ""
    end

    create unique_index(:users, [:username])
  end
end