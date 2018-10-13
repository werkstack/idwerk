defmodule IdWerk.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :email, :string
      add :password_hash, :string
      add :first_name, :string
      add :last_name, :string
      add :group_id, references(:groups, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:users, [:group_id])
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
