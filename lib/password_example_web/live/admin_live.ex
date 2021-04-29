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
  def handle_event("change_hash_type", %{"change_hash_type" => %{"hash_type" => hash_type_str}}, socket) do
    hash_type = String.to_atom(hash_type_str)
    HashingAlgorithmChoice.set(hash_type)
    socket = socket
      |> assign(hash_type: hash_type)
      |> put_flash(:info, "Changed hash type to " <> hash_type_str)
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_all_users", _, socket) do
    User.delete_all()
    {:noreply, socket}
  end
end
