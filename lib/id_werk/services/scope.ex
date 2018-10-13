defmodule IdWerk.Services.Scope do
  use Ecto.Schema
  import Ecto.Changeset
  alias IdWerk.Services.Service

  @name_regex ~r/^[a-z-0-9]+$/
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "scopes" do
    field :actions, {:array, :string}
    field :name, :string
    belongs_to :service, Service

    timestamps()
  end

  def create_changeset(scope, attrs) do
    scope
    |> cast(attrs, [:name, :actions])
    |> validate_format(:name, @name_regex, message: "only alphanumeric")
    |> multiple_validate_format(:actions, @name_regex, message: "only alphanumeric")
    |> put_assoc(:service, attrs[:service])
    |> validate_required([:name, :actions, :service])
    |> assoc_constraint(:service)
  end

  def changeset(scope, attrs) do
    scope
    |> cast(attrs, [:name, :actions])
    |> validate_format(:name, @name_regex, message: "only alphanumeric")
    |> multiple_validate_format(:actions, @name_regex, message: "only alphanumeric")
    |> validate_required([:name, :actions])
  end

  defp multiple_validate_format(changeset, field, format, opts) do
    validate_change(changeset, field, {:format, format}, fn _, values ->
      Enum.flat_map(values, fn value ->
        multiple_validate_format_internal(value, format, field, opts)
      end)
    end)
  end

  defp multiple_validate_format_internal(value, format, field, opts) do
    if value =~ format do
      []
    else
      [{field, {opts[:message], [validation: :format, value: value]}}]
    end
  end
end
