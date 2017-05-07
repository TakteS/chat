defmodule Chat.PageController do
  use Chat.Web, :controller

  def set_locale(conn, params, _current_user) do
    conn
    |> put_session(:locale, params["locale"])
    |> redirect(to: params["redirect_path"])
  end
end
