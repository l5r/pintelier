defmodule Pintelier.Drinking.ConsumptionSession do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "consumption_sessions" do
    field :last_consumption, :utc_datetime

    belongs_to :user, Pintelier.Accounts.User, type: :binary_id
    has_many :consumptions, Pintelier.Drinking.Consumption

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(consumption_session, attrs) do
    consumption_session
    |> cast(attrs, [:last_consumption])
    |> validate_required([:last_consumption])
  end
end
