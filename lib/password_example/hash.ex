defmodule PasswordExample.Hash do
  def partial_changeset password do
    algorithm = PasswordExample.HashingAlgorithmChoice.get()
    # todo: time
    {usecs_hashing_took, ret} = :timer.tc(&hash/2, [algorithm, password])
    Map.merge(
      %{password: nil, hashed_password: nil, salt: nil, hash_type: algorithm, useconds_hashing_took: usecs_hashing_took},
      ret
    )
  end
  defp hash :plaintext, password do
    %{password: password}
  end
  defp hash :sha1, password do
    %{hashed_password: get_sha1_hash(password)}
  end
  defp hash :sha1_with_salt, password do
    salt = make_salt()
    %{salt: salt, hashed_password: get_sha1_hash(password <> salt)}
  end
  defp hash :argon2id, password do
    %{hashed_password: Argon2.hash_pwd_salt(password)}
  end

  def verify attempted_password, %{hash_type: :plaintext, password: password} do
    attempted_password == password
  end
  def verify attempted_password, %{hash_type: :sha1, hashed_password: hashed_password} do
    get_sha1_hash(attempted_password) == hashed_password
  end
  def verify attempted_password, %{hash_type: :sha1_with_salt, salt: salt, hashed_password: hashed_password} do
    get_sha1_hash(attempted_password <> salt) == hashed_password
  end
  def verify attempted_password, %{hash_type: :argon2id, hashed_password: hashed_password} do
    Argon2.verify_pass(attempted_password, hashed_password)
  end
  def verify _, %{hash_type: :argon2id} do
    Argon2.no_user_verify()
  end

  defp get_sha1_hash password do
    :crypto.hash(:sha, password) |> Base.encode16()
  end
  defp make_salt(length \\ 12) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
