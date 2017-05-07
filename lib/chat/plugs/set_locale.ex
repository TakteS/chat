defmodule Chat.Plug.SetLocale do
  @moduledoc "Plug for put user's gettext locale"

  import Plug.Conn

  @available_locales Gettext.known_locales(Chat.Gettext)

  def init(opts \\ []), do: opts

  def call(conn, _opts) do
    locale = get_session(conn, :locale)
    if locale, do: put_locale(conn, locale), else: put_locale(conn, "en")
  end

  defp put_locale(conn, locale) when locale in @available_locales do
    Gettext.put_locale(Chat.Gettext, locale)

    conn
    |> assign(:locale, locale)
    |> put_session(:locale, locale)
  end
  defp put_locale(conn, _), do: conn |> put_session(:locale, "en")
end
