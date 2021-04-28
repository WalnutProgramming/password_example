defmodule PasswordExampleWeb.UsersTableComponent do
  use PasswordExampleWeb, :live_component
  alias PasswordExample.User

  @impl true
  def mount(socket) do
    if connected?(socket), do: User.subscribe()
    {:ok, assign(socket, users: User.get_all())}
  end

  def handle_info({:users_changed, users}) do
    {:noreply, users: users}
  end
end
