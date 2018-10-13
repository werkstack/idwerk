defmodule IdWerk.Repo.Migrations.CreateScopes do
  use Ecto.Migration

  def change do
    create table(:scopes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :actions, {:array, :string}

      add :service_id, references(:services, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:scopes, [:service_id])
  end
end
