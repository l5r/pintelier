defmodule Pintelier.Repo.Migrations.AddPublicToConsumptions do
  use Ecto.Migration

  def change do
    alter table(:consumptions) do
      add :is_public, :boolean, null: false, default: true
    end
  end
end
