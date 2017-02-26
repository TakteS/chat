defmodule Chat.LayoutView do
  use Chat.Web, :view
  use Phoenix.View, root: "web/templates", path: "layout"

  @doc """
  Generate unique page ID.
  """
  @spec page_id(Plug.Conn.t) :: String.t
  def page_id(conn) do
    controller =
      conn.private.phoenix_controller
      |> to_string()
      |> String.replace("Elixir.Chat.", "")
      |> String.replace("Controller", "")

    action =
      conn.private.phoenix_action
      |> to_string()
      |> String.capitalize

    controller <> action <> "View"
  end

  @doc """
  Check that user is admin.
  """
  @spec user_is_admin(Plug.Conn.t) :: boolean
  def user_is_admin(conn) do
    user = conn.assigns[:current_user]
    if user, do: user.role == "admin", else: false
  end
end
