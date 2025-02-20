defmodule Pintelier.Repo.Migrations.AddCaptionToConsumptions do
  use Ecto.Migration

  def change do
    alter table("consumptions") do
      add :caption, :string, null: true, default: nil
    end
  end
end
