defmodule IdWerkWeb.OAuthApiController do
  use IdWerkWeb, :controller

  alias IdWerk.{Services, JWT, Authorizations}

  plug IdWerkWeb.Plug.BasicAuthorizationHeaderPlug

  def auth_jwt(conn, %{"service" => _, "scope" => _} = params) do
    # params = %{"account" => "sam", "scope" => "repository:sam/data:push,pull", "service" => "registry.local"}
    # any error here we send access: []
    user = conn.assigns.authenticated_user
    service = Services.get_service_by(name: params["service"])

    access =
      case Authorizations.parse_docker_scope(params["scope"]) do
        {:ok, request_scope} ->
          Authorizations.access_list(user, service, request_scope)

        :error ->
          []
      end

    access_token = JWT.create_auth_token(user, service, access)

    token = %{
      access_token: access_token,
      expires_in: 300,
      issued_at: DateTime.to_iso8601(DateTime.utc_now())
    }

    render(conn, :auth_jwt, token: token)
  end

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
