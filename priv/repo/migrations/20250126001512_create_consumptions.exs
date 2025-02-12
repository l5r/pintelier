defmodule Pintelier.Repo.Migrations.CreateConsumptions do
  use Ecto.Migration

  def change do
    create table(:consumptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :volume_cl, :integer, null: false
      add :name, :string, null: false
      add :abv, :decimal, null: false, precision: 4, scale: 2
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :drink_id, references(:drinks, on_delete: :nilify_all, type: :binary_id), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:consumptions, [:user_id])
    create index(:consumptions, [:drink_id])
  end
end
