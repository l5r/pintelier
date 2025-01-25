defmodule Pintelier.AdminTest do
  use Pintelier.DataCase

  alias Pintelier.Admin

  describe "drinks" do
    alias Pintelier.Admin.Drink

    import Pintelier.AdminFixtures

    @invalid_attrs %{abv: nil, name: nil}

    test "list_drinks/0 returns all drinks" do
      drink = drink_fixture()
      assert Admin.list_drinks() == [drink]
    end

    test "get_drink!/1 returns the drink with given id" do
      drink = drink_fixture()
      assert Admin.get_drink!(drink.id) == drink
    end

    test "create_drink/1 with valid data creates a drink" do
      valid_attrs = %{abv: "120.5", name: "some name"}

      assert {:ok, %Drink{} = drink} = Admin.create_drink(valid_attrs)
      assert drink.abv == Decimal.new("120.5")
      assert drink.name == "some name"
    end

    test "create_drink/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_drink(@invalid_attrs)
    end

    test "update_drink/2 with valid data updates the drink" do
      drink = drink_fixture()
      update_attrs = %{abv: "456.7", name: "some updated name"}

      assert {:ok, %Drink{} = drink} = Admin.update_drink(drink, update_attrs)
      assert drink.abv == Decimal.new("456.7")
      assert drink.name == "some updated name"
    end

    test "update_drink/2 with invalid data returns error changeset" do
      drink = drink_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_drink(drink, @invalid_attrs)
      assert drink == Admin.get_drink!(drink.id)
    end

    test "delete_drink/1 deletes the drink" do
      drink = drink_fixture()
      assert {:ok, %Drink{}} = Admin.delete_drink(drink)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_drink!(drink.id) end
    end

    test "change_drink/1 returns a drink changeset" do
      drink = drink_fixture()
      assert %Ecto.Changeset{} = Admin.change_drink(drink)
    end
  end
end
