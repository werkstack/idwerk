defmodule IdWerk.AccountsTest do
  use IdWerk.DataCase

  alias IdWerk.Accounts

  describe "groups" do
    alias IdWerk.Accounts.Group

    @valid_attrs %{name: "some name", type: :user}
    @update_attrs %{name: "some updated name", type: :organization}
    @invalid_attrs %{name: nil, type: nil}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_group()

      group
    end

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Accounts.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Accounts.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Accounts.create_group(@valid_attrs)
      assert group.name == "some name"
      assert group.type == :user
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, %Group{} = group} = Accounts.update_group(group, @update_attrs)

      assert group.name == "some updated name"
      assert group.type == :organization
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_group(group, @invalid_attrs)
      assert group == Accounts.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Accounts.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Accounts.change_group(group)
    end
  end

  describe "users" do
    alias IdWerk.Accounts.User

    @valid_attrs %{
      email: "some email",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "some password_hash",
      username: "some username"
    }
    @update_attrs %{
      email: "some updated email",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      password: "some updated password_hash",
      username: "some updated username"
    }
    @invalid_attrs %{
      email: nil,
      first_name: nil,
      last_name: nil,
      password_hash: nil,
      username: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      user_id = user.id
      assert [%{id: ^user_id}] = Accounts.list_users()
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      user_id = user.id
      assert %{id: ^user_id} = Accounts.get_user!(user.id)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.password
      assert user.username == "some username"
      assert user.group_id
      assert user.group.type == :user
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)

      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      user_id = user.id
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert %{id: ^user_id} = Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
