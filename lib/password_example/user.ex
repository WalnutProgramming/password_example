defmodule PasswordExample.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string
    field :hashed_password, :string
    field :salt, :string
    field :useconds_hashing_took, :integer
    field :hash_type, Ecto.Enum, values: PasswordExample.HashingAlgorithmChoice.choices

    timestamps()
  end

  alias PasswordExample.{User, Repo}
  def create(attrs \\ %{}) do
    ret = %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    users_changed()
    ret
  end

  def delete_all do
    ret = Repo.delete_all(User)
    users_changed()
    ret
  end

  def get_all do
    Repo.all(User)
  end

  def get_by_name_and_password(name, password) do
    user = Repo.get_by(User, name: name)
    if user && PasswordExample.Hash.verify(password, user), do: user
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_name()
    |> validate_password()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_length(:name, min: 2)
    |> unsafe_validate_unique(:name, PasswordExample.Repo)
    |> unique_constraint(:name)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    # |> validate_length(:password, min: 12, max: 80)
    |> maybe_hash_password()
  end

  defp maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    # We only need to hash the password if the password is being changed
    if password && changeset.valid? do
      %{password: password, hashed_password: hashed_password, salt: salt, hash_type: hash_type, useconds_hashing_took: useconds_hashing_took} = PasswordExample.Hash.partial_changeset(password)
      changeset
      |> put_change(:password, password)
      |> put_change(:hashed_password, hashed_password)
      |> put_change(:salt, salt)
      |> put_change(:hash_type, hash_type)
      |> put_change(:useconds_hashing_took, useconds_hashing_took)
    else
      changeset
    end
  end

  ## users PubSub
  @topic "users"

  def subscribe do
    Phoenix.PubSub.subscribe(PasswordExample.PubSub, @topic)
  end

  def users_changed do
    Phoenix.PubSub.broadcast(PasswordExample.PubSub, @topic, {:users_changed, get_all()})
  end
end
