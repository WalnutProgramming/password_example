defmodule PasswordExample.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :password, :string
      add :hashed_password, :string
      add :salt, :string
      add :useconds_hashing_took, :integer
      add :hash_type, :string

      timestamps()
    end

  end
end
