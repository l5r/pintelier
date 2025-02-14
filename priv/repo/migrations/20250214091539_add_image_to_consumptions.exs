defmodule Pintelier.Repo.Migrations.AddImageToConsumptions do
  use Ecto.Migration

  def change do
    alter table("consumptions") do
      add :image, :string
    end
  end
end
