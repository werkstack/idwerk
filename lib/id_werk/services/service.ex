defmodule IdWerk.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset
  alias IdWerk.Services.Scope

  @valid_regex_name ~r/^([a-z0-9]+(-[a-z0-9]+)*\.?)+[a-z]{2,}$/i

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "services" do
    field :name, :string

    has_many :scopes, Scope

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_format(:name, @valid_regex_name)
    |> unique_constraint(:name)
  end
end
