defmodule PasswordExample.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :seconds_hashing_took, :float

    timestamps()
  end

  alias PasswordExample.{User, Repo}
  def create(attrs \\ %{}) do
    users_changed()
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(User)
  end

  def get_by_name_and_password(name, password) do
    user = Repo.get_by(User, name: name)
    if valid_password?(user, password), do: user
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
      {usecs_hashing_took, hashed_password} = :timer.tc(Argon2, :hash_pwd_salt, [password])

      seconds_hashing_took = usecs_hashing_took / 1_000_000

      IO.puts(seconds_hashing_took)

      changeset
      |> put_change(:hashed_password, hashed_password)
      |> put_change(:seconds_hashing_took, seconds_hashing_took)
      |> delete_change(:password)
    else
      changeset
    end
  end

  def valid_password?(%User{hashed_password: hashed_password}, password) do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
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
