defmodule PintelierWeb.DrinkLiveTest do
  use PintelierWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pintelier.AdminFixtures

  @create_attrs %{abv: "120.5", name: "some name"}
  @update_attrs %{abv: "456.7", name: "some updated name"}
  @invalid_attrs %{abv: nil, name: nil}

  defp create_drink(_) do
    drink = drink_fixture()
    %{drink: drink}
  end

  describe "Index" do
    setup [:create_drink]

    test "lists all drinks", %{conn: conn, drink: drink} do
      {:ok, _index_live, html} = live(conn, ~p"/drinks")

      assert html =~ "Listing Drinks"
      assert html =~ drink.name
    end

    test "saves new drink", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/drinks")

      assert index_live |> element("a", "New Drink") |> render_click() =~
               "New Drink"

      assert_patch(index_live, ~p"/drinks/new")

      assert index_live
             |> form("#drink-form", drink: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#drink-form", drink: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/drinks")

      html = render(index_live)
      assert html =~ "Drink created successfully"
      assert html =~ "some name"
    end

    test "updates drink in listing", %{conn: conn, drink: drink} do
      {:ok, index_live, _html} = live(conn, ~p"/drinks")

      assert index_live |> element("#drinks-#{drink.id} a", "Edit") |> render_click() =~
               "Edit Drink"

      assert_patch(index_live, ~p"/drinks/#{drink}/edit")

      assert index_live
             |> form("#drink-form", drink: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#drink-form", drink: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/drinks")

      html = render(index_live)
      assert html =~ "Drink updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes drink in listing", %{conn: conn, drink: drink} do
      {:ok, index_live, _html} = live(conn, ~p"/drinks")

      assert index_live |> element("#drinks-#{drink.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#drinks-#{drink.id}")
    end
  end

  describe "Show" do
    setup [:create_drink]

    test "displays drink", %{conn: conn, drink: drink} do
      {:ok, _show_live, html} = live(conn, ~p"/drinks/#{drink}")

      assert html =~ "Show Drink"
      assert html =~ drink.name
    end

    test "updates drink within modal", %{conn: conn, drink: drink} do
      {:ok, show_live, _html} = live(conn, ~p"/drinks/#{drink}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Drink"

      assert_patch(show_live, ~p"/drinks/#{drink}/show/edit")

      assert show_live
             |> form("#drink-form", drink: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#drink-form", drink: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/drinks/#{drink}")

      html = render(show_live)
      assert html =~ "Drink updated successfully"
      assert html =~ "some updated name"
    end
  end
end
