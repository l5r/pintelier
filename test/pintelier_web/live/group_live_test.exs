defmodule PintelierWeb.GroupLiveTest do
  use PintelierWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pintelier.GroupsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_group(_) do
    group = group_fixture()
    %{group: group}
  end

  describe "Index" do
    setup [:create_group]

    test "lists all groups", %{conn: conn, group: group} do
      {:ok, _index_live, html} = live(conn, ~p"/groups")

      assert html =~ "Listing Groups"
      assert html =~ group.name
    end

    test "saves new group", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/groups")

      assert index_live |> element("a", "New Group") |> render_click() =~
               "New Group"

      assert_patch(index_live, ~p"/groups/new")

      assert index_live
             |> form("#group-form", group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#group-form", group: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/groups")

      html = render(index_live)
      assert html =~ "Group created successfully"
      assert html =~ "some name"
    end

    test "updates group in listing", %{conn: conn, group: group} do
      {:ok, index_live, _html} = live(conn, ~p"/groups")

      assert index_live |> element("#groups-#{group.id} a", "Edit") |> render_click() =~
               "Edit Group"

      assert_patch(index_live, ~p"/groups/#{group}/edit")

      assert index_live
             |> form("#group-form", group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#group-form", group: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/groups")

      html = render(index_live)
      assert html =~ "Group updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes group in listing", %{conn: conn, group: group} do
      {:ok, index_live, _html} = live(conn, ~p"/groups")

      assert index_live |> element("#groups-#{group.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#groups-#{group.id}")
    end
  end

  describe "Show" do
    setup [:create_group]

    test "displays group", %{conn: conn, group: group} do
      {:ok, _show_live, html} = live(conn, ~p"/groups/#{group}")

      assert html =~ "Show Group"
      assert html =~ group.name
    end

    test "updates group within modal", %{conn: conn, group: group} do
      {:ok, show_live, _html} = live(conn, ~p"/groups/#{group}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Group"

      assert_patch(show_live, ~p"/groups/#{group}/show/edit")

      assert show_live
             |> form("#group-form", group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#group-form", group: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/groups/#{group}")

      html = render(show_live)
      assert html =~ "Group updated successfully"
      assert html =~ "some updated name"
    end
  end
end
