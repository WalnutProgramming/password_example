defmodule PasswordExampleWeb.HackLive do
  use PasswordExampleWeb, :live_view
  alias PasswordExample.{Repo, User}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: User.subscribe()
    {:ok, assign(socket, users: get_all_users())}
  end

  def handle_info(:changed) do
    {:noreply, users: get_all_users()}
  end

  def get_all_users() do
    Repo.all(User)
  end
end
