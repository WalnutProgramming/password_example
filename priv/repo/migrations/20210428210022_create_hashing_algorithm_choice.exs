defmodule PasswordExample.Repo.Migrations.CreateHashingAlgorithmChoice do
  use Ecto.Migration

  def change do
    create table(:hashing_algorithm_choice) do
      add :choice, :string

      timestamps()
    end

  end
end
