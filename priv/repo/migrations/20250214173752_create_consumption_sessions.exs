defmodule Pintelier.Repo.Migrations.CreateConsumptionSessions do
  use Ecto.Migration

  def change do
    create table(:consumption_sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :last_consumption, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:consumption_sessions, [:user_id])
  end
end
