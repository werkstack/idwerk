defmodule IdWerkWeb.Plug.BasicAuthorizationHeaderPlug do
  use Plug.Builder

  alias IdWerk.Accounts

  def init(opts) do
    [realm: opts[:realm] || "Realm"]
  end

  def call(conn, opts) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> attempted_auth] -> verify(conn, opts, attempted_auth)
      _ -> unauthorized(conn, opts)
    end
  end

  defp verify(conn, opts, attempted_auth) do
    with {:ok, user_pass} <- Base.decode64(attempted_auth),
         [username, password] <- String.split(user_pass, ":"),
         {:ok, user} <- Accounts.validate_password(username, password) do
      assign(conn, :authenticated_user, user)
    else
      _ ->
        unauthorized(conn, opts)
    end
  end

  defp unauthorized(conn, opts) do
    conn
    |> put_resp_header("www-authenticate", opts[:realm])
    |> put_resp_content_type("application/problem+json")
    # TODO: use RFC 7807 for error response
    |> send_resp(:unauthorized, "{}")
    |> halt()
  end
end
