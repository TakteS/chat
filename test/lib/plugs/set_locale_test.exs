defmodule Chat.Plug.SetLocaleTest do
  use   Chat.ConnCase
  alias Chat.Plug.SetLocale

  describe "call/2" do
    setup do
      conn = session_conn()
      {:ok, conn: conn}
    end

    test "put a locale", ctx do
      assert Gettext.get_locale(Chat.Gettext) == "en"

      conn = put_session(ctx.conn, :locale, "ru") |> SetLocale.call([])

      assert Gettext.get_locale(Chat.Gettext) == "ru"
      assert get_session(conn, :locale) == "ru"
    end

    test "put en locale when locale is not available", ctx do
      assert Gettext.get_locale(Chat.Gettext) == "en"

      conn = put_session(ctx.conn, :locale, "fake") |> SetLocale.call([])

      assert Gettext.get_locale(Chat.Gettext) == "en"
      assert get_session(conn, :locale) == "en"
    end
  end
end
