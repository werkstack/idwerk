defmodule IdWerk.AuthorizationsTest do
  use IdWerk.DataCase

  alias IdWerk.Authorizations

  describe "resources" do
    alias IdWerk.Authorizations.Resource

    @valid_attrs %{actions: [], identifier: "some identifier"}
    @update_attrs %{actions: [], identifier: "some updated identifier"}
    @invalid_attrs %{actions: nil, identifier: nil}

    test "list_resources/0 returns all resources" do
      resource = resource_fixture()
      resource_id = resource.id
      assert [%{id: ^resource_id}] = Authorizations.list_resources()
    end

    test "get_resource!/1 returns the resource with given id" do
      resource = resource_fixture()
      assert Authorizations.get_resource!(resource.id).id == resource.id
    end

    test "create_resource/1 with valid data creates a resource" do
      scope = scope_fixture()
      user = user_fixture()

      attrs =
        @valid_attrs
        |> Map.put(:scope, scope)
        |> Map.put(:group, user.group)

      assert {:ok, %Resource{} = resource} = Authorizations.create_resource(attrs)
      assert resource.actions == []
      assert resource.identifier == "some identifier"
    end

    test "create_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authorizations.create_resource(@invalid_attrs)
    end

    test "update_resource/2 with valid data updates the resource" do
      resource = resource_fixture()

      assert {:ok, %Resource{} = resource} =
               Authorizations.update_resource(resource, @update_attrs)

      assert resource.actions == []
      assert resource.identifier == "some updated identifier"
    end

    test "update_resource/2 with invalid data returns error changeset" do
      resource = resource_fixture()
      resource_id = resource.id

      assert {:error, %Ecto.Changeset{}} =
               Authorizations.update_resource(resource, @invalid_attrs)

      assert %{id: ^resource_id} = Authorizations.get_resource!(resource.id)
    end

    test "delete_resource/1 deletes the resource" do
      resource = resource_fixture()
      assert {:ok, %Resource{}} = Authorizations.delete_resource(resource)
      assert_raise Ecto.NoResultsError, fn -> Authorizations.get_resource!(resource.id) end
    end

    test "change_resource/1 returns a resource changeset" do
      resource = resource_fixture()
      assert %Ecto.Changeset{} = Authorizations.change_resource(resource)
    end
  end
end
