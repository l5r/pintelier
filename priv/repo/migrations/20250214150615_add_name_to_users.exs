defmodule Pintelier.Repo.Migrations.AddNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false, default: "Anonymous"
    end
  end
end
