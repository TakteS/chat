defmodule Chat.RoomChannelTest do
  use    Chat.ChannelCase
  alias  Chat.{ChatSocket, RoomChannel, Repo, Message, TestUtils}
  import Chat.Factory

  setup do
    user = insert(:user)
    room = insert(:room)
    {:ok, user: user, room: room}
  end

  describe "connect to socket" do
    test "when token is valid", ctx do
      assert {:ok, _socket} = connect(ChatSocket, %{"token" => ctx.user.token})
    end

    test "when token is invalid" do
      assert :error = connect(ChatSocket, %{"token" => "fake token"})
    end
  end

  describe "join to room" do
    test "when room is exists", ctx do
      assert {:ok, socket}          =  connect(ChatSocket, %{"token" => ctx.user.token})
      assert {:ok, _, socket}       =  subscribe_and_join(socket, RoomChannel, "room:#{ctx.room.id}")
      assert socket.assigns[:token] == ctx.user.token

      topic = "join_room:#{ctx.room.id}"
      push socket, topic, %{"token" => ctx.user.token, "room_id" => ctx.room.id}
      assert_broadcast ^topic, %{username: username}
      assert username == ctx.user.username
    end

    test "when room is not exists", ctx do
      assert {:ok, socket} = connect(ChatSocket, %{"token" => ctx.user.token})
      assert {:error, %{reason: "room is not exists"}} = subscribe_and_join(socket, RoomChannel, "room:#{0}")
    end
  end

  describe "push a message" do
    test "when message are valid", ctx do
      assert {:ok, socket}    = connect(ChatSocket, %{"token" => ctx.user.token})
      assert {:ok, _, socket} = subscribe_and_join(socket, RoomChannel, "room:#{ctx.room.id}")

      topic    = "new_message:#{ctx.room.id}"
      username = ctx.user.username

      push socket, topic, %{"message" => "Hello world!", "token" => ctx.user.token}
      assert_broadcast ^topic, %{username: ^username, message: "Hello world!"}
      assert Repo.get_by(Message, [user_id: ctx.user.id, room_id: ctx.room.id, body: "Hello world!"])
    end

    test "when message are invalid", ctx do
      assert {:ok, socket}    = connect(ChatSocket, %{"token" => ctx.user.token})
      assert {:ok, _, socket} = subscribe_and_join(socket, RoomChannel, "room:#{ctx.room.id}")

      message  = TestUtils.random_string(101)
      topic    = "new_message:#{ctx.room.id}"
      username = ctx.user.username

      push socket, topic, %{"message" => message, "token" => ctx.user.token}
      refute_broadcast ^topic, %{username: ^username, message: ^message}
      refute Repo.get_by(Message, [user_id: ctx.user.id, room_id: ctx.room.id, body: message])
    end
  end
end
