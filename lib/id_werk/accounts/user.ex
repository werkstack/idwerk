defmodule IdWerk.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias IdWerk.Accounts.Group

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :username, :string
    belongs_to :group, Group

    field :password, :string, virtual: true

    timestamps()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :first_name, :last_name, :password])
    |> cast_assoc(:group, required: true, with: &Group.changeset/2)
    |> put_pass_hash()
    |> validate_required([:username, :email, :password_hash, :first_name, :last_name, :group])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> assoc_constraint(:group)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password_hash, :first_name, :last_name])
    |> validate_required([:username, :email, :password_hash, :first_name, :last_name])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> assoc_constraint(:group)
  end
end
