defmodule PasswordExampleWeb.UsersTableComponent do
  use PasswordExampleWeb, :live_component
  alias PasswordExample.User

  @impl true
  def mount(socket) do
    if connected?(socket), do: User.subscribe()
    {:ok, assign(socket, users: User.get_all())}
  end

  @impl true
  def handle_event(_event, _unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def update(%{users: users}, socket) do
    {:ok, assign(socket, users: users)}
  end
  def update(_, socket) do
    {:ok, socket}
  end
end
