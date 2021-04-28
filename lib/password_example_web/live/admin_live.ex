defmodule PasswordExampleWeb.AdminLive do
  use PasswordExampleWeb, :live_view
  # use Phoenix.HTML
  alias PasswordExampleWeb.UsersTableComponent
  alias PasswordExample.{HashingAlgorithmChoice, User}

  @impl true
  def mount(_, _, socket) do
    {:ok, assign(socket, hash_type: HashingAlgorithmChoice.get())}
  end

  @impl true
  def handle_event("change_hash_type", %{"value" => hash_type}, socket) do
    hash_type = String.to_atom(hash_type)
    HashingAlgorithmChoice.set(hash_type)
    User.delete_all()
    {:noreply, assign(socket, hash_type: hash_type)}
  end
end
