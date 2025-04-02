defmodule Pintelier.Repo.Migrations.CreateGroupInvitations do
  use Ecto.Migration

  def change do
    create table(:group_invitations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :expiration, :utc_datetime
      add :group_id, references(:groups, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:group_invitations, [:group_id])
  end
end
