defmodule PasswordExample.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :hashed_password, :string
      add :seconds_hashing_took, :float

      timestamps()
    end

  end
end
