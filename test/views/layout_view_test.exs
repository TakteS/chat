defmodule Chat.LayoutViewTest do
  use    Chat.ConnCase, async: true
  alias  Chat.LayoutView
  import Chat.Factory

  test "page_id/1" do
    user = insert(:user)
    conn = build_conn()

    user_new_conn = get(conn, user_path(conn, :new))
    assert LayoutView.page_id(user_new_conn) == "UserNewView"

    auth_conn = auth_conn(user)
    room_index_conn = get(auth_conn, room_path(auth_conn, :index))
    assert LayoutView.page_id(room_index_conn) == "RoomIndexView"
  end

  test "user_is_admin/1" do
    # When user is not authenticated
    conn = build_conn()
    refute LayoutView.user_is_admin(conn)

    # When user is not admin
    user      = insert(:user)
    user_conn = auth_conn(user)
    refute LayoutView.user_is_admin(user_conn)

    # When user is admin
    admin      = insert(:user, role: "admin")
    admin_conn = auth_conn(admin)
    assert LayoutView.user_is_admin(admin_conn)
  end
end
