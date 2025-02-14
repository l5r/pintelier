defmodule Pintelier.Repo.Migrations.AddSessionToConsumptions do
  use Ecto.Migration

  def change do
    alter table(:consumptions) do
      add :consumption_session_id, references(:consumption_sessions, on_delete: :delete_all, type: :binary_id)
    end

    create index(:consumptions, [:consumption_session_id])
  end
end
