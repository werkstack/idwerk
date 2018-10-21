defmodule IdWerk.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def up do
    GroupTypeEnum.create_type()

    create table(:groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :type, :group_type

      timestamps()
    end
  end

  def down do
    drop table(:groups)
    GroupTypeEnum.drop_type()
  end
end
