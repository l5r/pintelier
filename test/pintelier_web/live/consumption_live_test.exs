defmodule PintelierWeb.ConsumptionLiveTest do
  use PintelierWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pintelier.DrinkingFixtures

  @create_attrs %{abv: "120.5", name: "some name", volume_cl: 42}
  @update_attrs %{abv: "456.7", name: "some updated name", volume_cl: 43}
  @invalid_attrs %{abv: nil, name: nil, volume_cl: nil}

  defp create_consumption(_) do
    consumption = consumption_fixture()
    %{consumption: consumption}
  end

  describe "Index" do
    setup [:create_consumption]

    test "lists all consumptions", %{conn: conn, consumption: consumption} do
      {:ok, _index_live, html} = live(conn, ~p"/consumptions")

      assert html =~ "Listing Consumptions"
      assert html =~ consumption.name
    end

    test "saves new consumption", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/consumptions")

      assert index_live |> element("a", "New Consumption") |> render_click() =~
               "New Consumption"

      assert_patch(index_live, ~p"/consumptions/new")

      assert index_live
             |> form("#consumption-form", consumption: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#consumption-form", consumption: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/consumptions")

      html = render(index_live)
      assert html =~ "Consumption created successfully"
      assert html =~ "some name"
    end

    test "updates consumption in listing", %{conn: conn, consumption: consumption} do
      {:ok, index_live, _html} = live(conn, ~p"/consumptions")

      assert index_live |> element("#consumptions-#{consumption.id} a", "Edit") |> render_click() =~
               "Edit Consumption"

      assert_patch(index_live, ~p"/consumptions/#{consumption}/edit")

      assert index_live
             |> form("#consumption-form", consumption: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#consumption-form", consumption: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/consumptions")

      html = render(index_live)
      assert html =~ "Consumption updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes consumption in listing", %{conn: conn, consumption: consumption} do
      {:ok, index_live, _html} = live(conn, ~p"/consumptions")

      assert index_live |> element("#consumptions-#{consumption.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#consumptions-#{consumption.id}")
    end
  end

  describe "Show" do
    setup [:create_consumption]

    test "displays consumption", %{conn: conn, consumption: consumption} do
      {:ok, _show_live, html} = live(conn, ~p"/consumptions/#{consumption}")

      assert html =~ "Show Consumption"
      assert html =~ consumption.name
    end

    test "updates consumption within modal", %{conn: conn, consumption: consumption} do
      {:ok, show_live, _html} = live(conn, ~p"/consumptions/#{consumption}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Consumption"

      assert_patch(show_live, ~p"/consumptions/#{consumption}/show/edit")

      assert show_live
             |> form("#consumption-form", consumption: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#consumption-form", consumption: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/consumptions/#{consumption}")

      html = render(show_live)
      assert html =~ "Consumption updated successfully"
      assert html =~ "some updated name"
    end
  end
end
