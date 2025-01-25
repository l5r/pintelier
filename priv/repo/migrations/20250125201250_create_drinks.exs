defmodule Pintelier.Repo.Migrations.CreateDrinks do
  use Ecto.Migration

  def change do
    create table(:drinks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :abv, :decimal, null: false, precision: 4, scale: 2

      timestamps(type: :utc_datetime)
    end
  end
end
