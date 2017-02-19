defmodule Chat.Router do
  use Chat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Chat.Plug.Auth, repo: Chat.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Chat do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/register", UserController, :new
    put "/register", UserController, :create

    get  "/login", UserController, :login
    post "/login", UserController, :do_login

    delete "/logout", UserController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", Chat do
  #   pipe_through :api
  # end
end
