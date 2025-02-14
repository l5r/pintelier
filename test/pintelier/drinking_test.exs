defmodule Pintelier.DrinkingTest do
  use Pintelier.DataCase

  alias Pintelier.Drinking

  describe "consumptions" do
    alias Pintelier.Drinking.Consumption

    import Pintelier.DrinkingFixtures

    @invalid_attrs %{abv: nil, name: nil, volume_cl: nil}

    test "list_consumptions/0 returns all consumptions" do
      consumption = consumption_fixture()
      assert Drinking.list_consumptions() == [consumption]
    end

    test "get_consumption!/1 returns the consumption with given id" do
      consumption = consumption_fixture()
      assert Drinking.get_consumption!(consumption.id) == consumption
    end

    test "create_consumption/1 with valid data creates a consumption" do
      valid_attrs = %{abv: "120.5", name: "some name", volume_cl: 42}

      assert {:ok, %Consumption{} = consumption} = Drinking.create_consumption(valid_attrs)
      assert consumption.abv == Decimal.new("120.5")
      assert consumption.name == "some name"
      assert consumption.volume_cl == 42
    end

    test "create_consumption/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drinking.create_consumption(@invalid_attrs)
    end

    test "update_consumption/2 with valid data updates the consumption" do
      consumption = consumption_fixture()
      update_attrs = %{abv: "456.7", name: "some updated name", volume_cl: 43}

      assert {:ok, %Consumption{} = consumption} = Drinking.update_consumption(consumption, update_attrs)
      assert consumption.abv == Decimal.new("456.7")
      assert consumption.name == "some updated name"
      assert consumption.volume_cl == 43
    end

    test "update_consumption/2 with invalid data returns error changeset" do
      consumption = consumption_fixture()
      assert {:error, %Ecto.Changeset{}} = Drinking.update_consumption(consumption, @invalid_attrs)
      assert consumption == Drinking.get_consumption!(consumption.id)
    end

    test "delete_consumption/1 deletes the consumption" do
      consumption = consumption_fixture()
      assert {:ok, %Consumption{}} = Drinking.delete_consumption(consumption)
      assert_raise Ecto.NoResultsError, fn -> Drinking.get_consumption!(consumption.id) end
    end

    test "change_consumption/1 returns a consumption changeset" do
      consumption = consumption_fixture()
      assert %Ecto.Changeset{} = Drinking.change_consumption(consumption)
    end
  end

  describe "consumption_sessions" do
    alias Pintelier.Drinking.ConsumptionSession

    import Pintelier.DrinkingFixtures

    @invalid_attrs %{last_consumption: nil}

    test "list_consumption_sessions/0 returns all consumption_sessions" do
      consumption_session = consumption_session_fixture()
      assert Drinking.list_consumption_sessions() == [consumption_session]
    end

    test "get_consumption_session!/1 returns the consumption_session with given id" do
      consumption_session = consumption_session_fixture()
      assert Drinking.get_consumption_session!(consumption_session.id) == consumption_session
    end

    test "create_consumption_session/1 with valid data creates a consumption_session" do
      valid_attrs = %{last_consumption: ~U[2025-02-13 17:37:00Z]}

      assert {:ok, %ConsumptionSession{} = consumption_session} = Drinking.create_consumption_session(valid_attrs)
      assert consumption_session.last_consumption == ~U[2025-02-13 17:37:00Z]
    end

    test "create_consumption_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drinking.create_consumption_session(@invalid_attrs)
    end

    test "update_consumption_session/2 with valid data updates the consumption_session" do
      consumption_session = consumption_session_fixture()
      update_attrs = %{last_consumption: ~U[2025-02-14 17:37:00Z]}

      assert {:ok, %ConsumptionSession{} = consumption_session} = Drinking.update_consumption_session(consumption_session, update_attrs)
      assert consumption_session.last_consumption == ~U[2025-02-14 17:37:00Z]
    end

    test "update_consumption_session/2 with invalid data returns error changeset" do
      consumption_session = consumption_session_fixture()
      assert {:error, %Ecto.Changeset{}} = Drinking.update_consumption_session(consumption_session, @invalid_attrs)
      assert consumption_session == Drinking.get_consumption_session!(consumption_session.id)
    end

    test "delete_consumption_session/1 deletes the consumption_session" do
      consumption_session = consumption_session_fixture()
      assert {:ok, %ConsumptionSession{}} = Drinking.delete_consumption_session(consumption_session)
      assert_raise Ecto.NoResultsError, fn -> Drinking.get_consumption_session!(consumption_session.id) end
    end

    test "change_consumption_session/1 returns a consumption_session changeset" do
      consumption_session = consumption_session_fixture()
      assert %Ecto.Changeset{} = Drinking.change_consumption_session(consumption_session)
    end
  end
end
