defmodule IdWerkWeb.Router do
  use IdWerkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", IdWerkWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", IdWerkWeb do
    pipe_through :api
    get "/oauth2/v1/auth", OAuthApiController, :auth_jwt, as: :oauth_api
  end
end
