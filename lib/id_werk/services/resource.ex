defmodule IdWerk.Services.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  alias IdWerk.Services.Scope
  alias IdWerk.Accounts.Group

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "resources" do
    field :actions, {:array, :string}
    field :identifier, :string

    belongs_to :scope, Scope
    belongs_to :group, Group

    timestamps()
  end

  def create_changeset(resource, attrs) do
    resource
    |> cast(attrs, [:identifier, :actions])
    |> put_assoc(:group, attrs[:group])
    |> put_assoc(:scope, attrs[:scope])
    |> validate_required([:identifier, :actions])
    |> assoc_constraint(:group)
    |> assoc_constraint(:scope)
    |> unique_constraint(:resource, name: :group_id_scope_id_identifier_index)
  end

  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:identifier, :actions])
    |> validate_required([:identifier, :actions])
  end
end
