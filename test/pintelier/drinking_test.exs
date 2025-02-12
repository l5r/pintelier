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
end
