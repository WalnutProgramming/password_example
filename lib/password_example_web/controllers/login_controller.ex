defmodule PasswordExampleWeb.LoginController do
  use PasswordExampleWeb, :controller
  import Plug.Conn
  alias PasswordExample.{User, Repo}

  def register(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  def register_post(conn, %{"user" => user_params}) do
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

  def login(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "login.html", changeset: changeset)
  end

  def login_post(conn, %{"user" => user_params}) do
    %{"name" => name, "password" => password} = user_params

    if user = User.get_by_name_and_password(name, password) do
      conn
      |> put_flash(:info, "Logged in successfully.")
      |> put_session(:user, user.name)
      |> redirect(to: Routes.login_path(conn, :show))
    else
      conn
      |> put_flash(:error, "Invalid name or password")
      |> render("login.html")
    end
  end

  import Ecto.Query
  def show(conn, _params) do
    if name = get_session(conn, :user) do
      if user = Repo.one(from u in User, where: u.name == ^name) do
        render(conn, "show.html", user: user)
      else
        logged_out_from_show(conn)
      end
    else
      logged_out_from_show(conn)
    end
  end

  defp logged_out_from_show(conn) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> delete_session(:user)
    |> redirect(to: Routes.login_path(conn, :register))
  end
end
