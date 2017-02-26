defmodule Chat.RoomView do
  use    Chat.Web, :view
  use    Phoenix.View, root: "web/room", path: "templates"
  import Chat.LayoutView, only: [user_is_admin: 1]
end
