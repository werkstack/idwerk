defmodule IdWerk.Fixture do
  @valid_service_attrs %{name: "some-name"}
  @valid_scope_attrs %{actions: ["pull", "push"], name: "repository"}
  @valid_resource_attr %{actions: [], identifier: "some identifier"}

  alias IdWerk.{Accounts, Services, Authorizations}

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
    random = Base.encode16(:crypto.strong_rand_bytes(5), case: :lower)

    valid_user_attrs = %{
      first_name: "first",
      last_name: "last",
      name: "user-#{random}",
      username: "user#{random}",
      email: "email#{random}@email.com",
      password: "asasdsad"
    }

    {:ok, user} =
      attrs
      |> Enum.into(valid_user_attrs)
      |> Accounts.create_user()

    user
  end

  def resource_fixture(attrs \\ %{}) do
    scope = scope_fixture()
    user = attrs[:user] || user_fixture()

    {:ok, resource} =
      attrs
      |> Map.put(:scope, scope)
      |> Map.put(:user, user)
      |> Enum.into(@valid_resource_attr)
      |> Authorizations.create_resource()

    resource
  end
end
