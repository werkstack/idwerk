defmodule IdWerkWeb.OAuthApiController do
  use IdWerkWeb, :controller

  alias IdWerk.{Services, JWT}

  plug IdWerkWeb.Plug.BasicAuthorizationHeaderPlug

  def auth_jwt(conn, %{"service" => _} = params) do
    user = conn.assigns.authenticated_user

    with service = %{} <- Services.get_service_by(name: params["service"]),
         access <- lookup_access(service, params["scope"], user) do
      access_token = JWT.create_auth_token(user, service, access)

      token = %{
        access_token: access_token,
        expires_in: 300,
        issued_at: DateTime.to_iso8601(DateTime.utc_now())
      }

      render(conn, :auth_jwt, token: token)
    end
  end

  def lookup_access(_service, nil, _user) do
    []
  end
end
