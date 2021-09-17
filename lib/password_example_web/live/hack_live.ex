defmodule PasswordExampleWeb.HackLive do
  use PasswordExampleWeb, :live_view
  alias PasswordExampleWeb.UsersTableComponent

  @impl true
  def handle_info({:users_changed, users}, socket) do
    send_update UsersTableComponent, id: :users_table, users: users
    {:noreply, socket}
  end
end
