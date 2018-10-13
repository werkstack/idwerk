defmodule IdWerkWeb.TokenApiControllerTest do
  use IdWerkWeb.ConnCase

  describe "GET JWT token" do
    test "without Basic Authorization", %{conn: conn} do
      conn = get(conn, Routes.oauth_api_path(conn, :auth_jwt, %{}))
      assert json_response(conn, 401)
    end

    test "with invalid Basic Authorization", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Basic " <> Base.encode64("nouser:nopassword"))
        |> get(Routes.oauth_api_path(conn, :auth_jwt, %{}))

      assert json_response(conn, 401)
    end

    test "with valid Authorization header", %{conn: conn} do
      password = Base.encode64(:crypto.strong_rand_bytes(10))
      user = user_fixture(%{password: password})

      conn =
        conn
        |> put_req_header(
          "authorization",
          "Basic " <> Base.encode64("#{user.username}:#{password}")
        )
        |> get(Routes.oauth_api_path(conn, :auth_jwt, %{}))

      assert json_response(conn, 200)
      assert conn.assigns[:authenticated_user]
    end
  end
end
