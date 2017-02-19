defmodule Chat.PageController do
  use Chat.Web, :controller

  def index(conn, _params, _current_user) do
    render conn, "index.html"
  end
end
