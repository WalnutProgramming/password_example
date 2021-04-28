defmodule PasswordExample.HashingAlgorithmChoice do
  use Ecto.Schema
  # import Ecto.Changeset
  alias PasswordExample.{Repo, HashingAlgorithmChoice}

  @choices [:plaintext, :sha1, :sha1_with_salt, :argon2id]
  def choices, do: @choices

  schema "hashing_algorithm_choice" do
    field :choice, Ecto.Enum, values: @choices

    timestamps()
  end

  # @doc false
  # def changeset(hashing_algorithm_choice, attrs) do
  #   hashing_algorithm_choice
  #   |> cast(attrs, [:choice])
  #   |> validate_required([:choice])
  # end

  def get() do
    if existing = Repo.one(HashingAlgorithmChoice) do
      existing.choice
    else
      :plaintext
    end
  end
  def set(new_val) do
    if existing = Repo.one(HashingAlgorithmChoice) do
      Repo.update(Ecto.Changeset.change(existing, %{choice: new_val}))
    else
      Repo.insert(%HashingAlgorithmChoice{choice: new_val})
    end
  end
end
