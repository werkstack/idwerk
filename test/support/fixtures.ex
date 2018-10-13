defmodule IdWerk.Fixture do
  @valid_service_attrs %{name: "some-name"}
  @valid_scope_attrs %{actions: ["pull", "push"], name: "repository"}
  @valid_resource_attr %{actions: [], identifier: "some identifier"}
  @valid_user_attrs %{
    first_name: "first",
    last_name: "last",
    name: "som",
    username: "as",
    email: "asas",
    password: "asasdsad"
  }

  alias IdWerk.{Accounts, Services}

  def service_fixture(attrs \\ %{}) do
    {:ok, service} =
      attrs
      |> Enum.into(@valid_service_attrs)
      |> Services.create_service()

    service
  end

  def scope_fixture(attrs \\ %{}) do
    service = service_fixture()

    {:ok, scope} =
      attrs
      |> Map.put(:service, service)
      |> Enum.into(@valid_scope_attrs)
      |> Services.create_scope()

    scope
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> Accounts.create_user()

    user
  end

  def resource_fixture(attrs \\ %{}) do
    scope = scope_fixture()
    user = user_fixture()

    {:ok, resource} =
      attrs
      |> Map.put(:scope, scope)
      |> Map.put(:user, user)
      |> Enum.into(@valid_resource_attr)
      |> Services.create_resource()

    resource
  end
end
