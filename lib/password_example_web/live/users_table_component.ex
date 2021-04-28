defmodule PasswordExampleWeb.UsersTableComponent do
  use PasswordExampleWeb, :live_component
  alias PasswordExample.{Repo, User}

  @impl true
  def mount(socket) do
    if connected?(socket), do: User.subscribe()
    {:ok, assign(socket, users: get_all_users())}
  end

  def handle_info(:changed) do
    {:noreply, users: get_all_users()}
  end

  defp get_all_users() do
    Repo.all(User)
  end
end
