defmodule IdWerk.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :identifier, :string
      add :actions, {:array, :string}
      add :scope_id, references(:scopes, on_delete: :delete_all, type: :binary_id), null: false
      add :group_id, references(:groups, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:resources, [:scope_id])
    create index(:resources, [:group_id])
    create unique_index(:resources, [:group_id, :scope_id, :identifier])
  end
end
