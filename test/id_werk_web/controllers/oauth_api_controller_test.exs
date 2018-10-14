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
      scope = scope_fixture()

      params = %{service: scope.service.name}

      conn =
        conn
        |> put_req_header(
          "authorization",
          "Basic " <> Base.encode64("#{user.username}:#{password}")
        )
        |> get(Routes.oauth_api_path(conn, :auth_jwt, params))

      assert %{"access_token" => _} = json_response(conn, 200)
      assert conn.assigns[:authenticated_user]
    end

    test "with wildcard identifier, user should access to all resources", %{conn: conn} do
      password = Base.encode64(:crypto.strong_rand_bytes(10))
      user = user_fixture(%{password: password})

      %{scope: %{service: _service} = scope} =
        _resource = resource_fixture(%{identifier: "*", actions: ["push", "pull"], user: user})

      params = %{service: scope.service.name, scope: "repository:foo/bar:pull,push"}

      conn =
        conn
        |> put_req_header(
          "authorization",
          "Basic " <> Base.encode64("#{user.username}:#{password}")
        )
        |> get(Routes.oauth_api_path(conn, :auth_jwt, params))

      assert %{"access_token" => access_token} = json_response(conn, 200)
      [_, payload_encoded, _] = String.split(access_token, ".")

      payload =
        Base.decode64!(payload_encoded, padding: false)
        |> Jason.decode!()

      assert access = List.first(payload["access"])
      assert access["name"] == "foo/bar"
      assert access["actions"] == ["push", "pull"]
    end
  end
end
