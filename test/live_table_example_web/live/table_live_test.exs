defmodule LiveTableExampleWeb.TableLiveTest do
  use LiveTableExampleWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveTableExample.FormatsFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp create_table(_) do
    table = table_fixture()
    %{table: table}
  end

  describe "Index" do
    setup [:create_table]

    test "lists all tables", %{conn: conn, table: table} do
      {:ok, _index_live, html} = live(conn, Routes.table_index_path(conn, :index))

      assert html =~ "Listing Tables"
      assert html =~ table.title
    end

    test "saves new table", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.table_index_path(conn, :index))

      assert index_live |> element("a", "New Table") |> render_click() =~
               "New Table"

      assert_patch(index_live, Routes.table_index_path(conn, :new))

      assert index_live
             |> form("#table-form", table: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#table-form", table: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.table_index_path(conn, :index))

      assert html =~ "Table created successfully"
      assert html =~ "some title"
    end

    test "updates table in listing", %{conn: conn, table: table} do
      {:ok, index_live, _html} = live(conn, Routes.table_index_path(conn, :index))

      assert index_live |> element("#table-#{table.id} a", "Edit") |> render_click() =~
               "Edit Table"

      assert_patch(index_live, Routes.table_index_path(conn, :edit, table))

      assert index_live
             |> form("#table-form", table: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#table-form", table: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.table_index_path(conn, :index))

      assert html =~ "Table updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes table in listing", %{conn: conn, table: table} do
      {:ok, index_live, _html} = live(conn, Routes.table_index_path(conn, :index))

      assert index_live |> element("#table-#{table.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#table-#{table.id}")
    end
  end

  describe "Show" do
    setup [:create_table]

    test "displays table", %{conn: conn, table: table} do
      {:ok, _show_live, html} = live(conn, Routes.table_show_path(conn, :show, table))

      assert html =~ "Show Table"
      assert html =~ table.title
    end

    test "updates table within modal", %{conn: conn, table: table} do
      {:ok, show_live, _html} = live(conn, Routes.table_show_path(conn, :show, table))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Table"

      assert_patch(show_live, Routes.table_show_path(conn, :edit, table))

      assert show_live
             |> form("#table-form", table: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#table-form", table: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.table_show_path(conn, :show, table))

      assert html =~ "Table updated successfully"
      assert html =~ "some updated title"
    end
  end
end
