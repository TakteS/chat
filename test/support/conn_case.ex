defmodule Chat.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Chat.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Chat.Router.Helpers
      import Chat.ConnCase, only: [render_template: 1]

      # The default endpoint for testing
      @endpoint Chat.Endpoint

      def auth_conn(user),
        do: build_conn() |> assign(:current_user, user)

      def session_conn() do
        build_conn()
        |> bypass_through(Chat.Router, [:browser])
        |> get("/")
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Chat.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Chat.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def render_template(conn), do: conn.private.phoenix_template
end
