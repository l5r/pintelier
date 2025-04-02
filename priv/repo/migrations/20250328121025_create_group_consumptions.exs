defmodule Pintelier.Repo.Migrations.CreateGroupConsumptions do
  use Ecto.Migration

  def change do
    create table(:group_consumptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :group_id, references(:groups, on_delete: :delete_all, type: :binary_id), null: false
      add :consumption_id, references(:consumptions, on_delete: :delete_all, type: :binary_id), null: false
    end

    create index(:group_consumptions, [:group_id])
    create index(:group_consumptions, [:consumption_id])
    create index(:group_consumptions, [:group_id, :consumption_id], unique: true)
  end
end
