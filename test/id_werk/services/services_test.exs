defmodule IdWerk.ServicesTest do
  use IdWerk.DataCase

  alias IdWerk.Services

  describe "services" do
    alias IdWerk.Services.Service

    @valid_attrs %{name: "some-name"}
    @update_attrs %{name: "some.Updated-name-extra.local"}
    @invalid_attrs %{name: "some random name"}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Services.create_service()

      service
    end

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Services.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Services.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = Services.create_service(@valid_attrs)
      assert service.name == "some-name"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Services.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, %Service{} = service} = Services.update_service(service, @update_attrs)

      assert service.name == "some.Updated-name-extra.local"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Services.update_service(service, @invalid_attrs)
      assert service == Services.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Services.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Services.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Services.change_service(service)
    end
  end

  describe "scopes" do
    alias IdWerk.Services.Scope

    @valid_attrs %{actions: ["pull", "push"], name: "repository"}
    @update_attrs %{actions: ["pull-and-push"], name: "repository-access"}
    @invalid_attrs %{actions: nil, name: nil}

    def scope_fixture(attrs \\ %{}) do
      {:ok, service} = Services.create_service(%{name: "docker.foo.bar"})

      {:ok, scope} =
        attrs
        |> Map.put(:service, service)
        |> Enum.into(@valid_attrs)
        |> Services.create_scope()

      scope
    end

    test "list_scopes/0 returns all scopes" do
      scope = scope_fixture()
      scope_id = scope.id
      assert [%{id: ^scope_id}] = Services.list_scopes()
    end

    test "get_scope!/1 returns the scope with given id" do
      scope = scope_fixture()
      assert Services.get_scope!(scope.id).id == scope.id
    end

    test "create_scope/1 with valid data creates a scope" do
      service = service_fixture()

      assert {:ok, %Scope{} = scope} =
               Services.create_scope(Map.put(@valid_attrs, :service, service))

      assert scope.actions == ["pull", "push"]
      assert scope.name == "repository"
    end

    test "create_scope/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Services.create_scope(@invalid_attrs)
    end

    test "create_scope/1 with invalid action anems returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Services.create_scope(%{name: "name", actions: ["action with space"]})

      assert errors_on(changeset).actions == ["only alphanumeric"]
    end

    test "update_scope/2 with valid data updates the scope" do
      scope = scope_fixture()
      assert {:ok, %Scope{} = scope} = Services.update_scope(scope, @update_attrs)

      assert scope.actions == ["pull-and-push"]
      assert scope.name == "repository-access"
    end

    test "update_scope/2 with invalid data returns error changeset" do
      scope = scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Services.update_scope(scope, @invalid_attrs)
    end

    test "delete_scope/1 deletes the scope" do
      scope = scope_fixture()

      assert {:ok, %Scope{}} = Services.delete_scope(scope)
      assert_raise Ecto.NoResultsError, fn -> Services.get_scope!(scope.id) end
    end

    test "change_scope/1 returns a scope changeset" do
      scope = scope_fixture()

      assert %Ecto.Changeset{} = Services.change_scope(scope)
    end
  end
end
