defmodule IdWerkWeb.OAuthApiController do
  use IdWerkWeb, :controller

  plug IdWerkWeb.Plug.BasicAuthorizationHeaderPlug

  def auth_jwt(conn, _params) do
    render(conn, :auth_jwt)
  end
end
