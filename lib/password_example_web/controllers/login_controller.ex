defmodule PasswordExampleWeb.LoginController do
  use PasswordExampleWeb, :controller
  import Plug.Conn
  alias PasswordExample.{User, Repo}

  def register(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  # TODO: login

  def create(conn, %{"user" => user_params}) do
    case User.create(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:user, user.name)
        |> redirect(to: Routes.login_path(conn, :show))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  import Ecto.Query
  def show(conn, _params) do
    name = get_session(conn, :user)
    if name == nil do
      logged_out_from_show(conn)
    else
      user = Repo.one(from u in User, where: u.name == ^name)
      if user == nil do
        logged_out_from_show(conn)
      else
        render(conn, "show.html", user: user)
      end
    end
  end

  defp logged_out_from_show(conn) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> delete_session(:user)
    |> redirect(to: Routes.login_path(conn, :register))
  end
end
