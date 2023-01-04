defmodule LiveTableExample.FormatsTest do
  use LiveTableExample.DataCase

  alias LiveTableExample.Formats

  describe "tables" do
    alias LiveTableExample.Formats.Table

    import LiveTableExample.FormatsFixtures

    @invalid_attrs %{title: nil}

    test "list_tables/0 returns all tables" do
      table = table_fixture()
      assert Formats.list_tables() == [table]
    end

    test "get_table!/1 returns the table with given id" do
      table = table_fixture()
      assert Formats.get_table!(table.id) == table
    end

    test "create_table/1 with valid data creates a table" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Table{} = table} = Formats.create_table(valid_attrs)
      assert table.title == "some title"
    end

    test "create_table/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Formats.create_table(@invalid_attrs)
    end

    test "update_table/2 with valid data updates the table" do
      table = table_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Table{} = table} = Formats.update_table(table, update_attrs)
      assert table.title == "some updated title"
    end

    test "update_table/2 with invalid data returns error changeset" do
      table = table_fixture()
      assert {:error, %Ecto.Changeset{}} = Formats.update_table(table, @invalid_attrs)
      assert table == Formats.get_table!(table.id)
    end

    test "delete_table/1 deletes the table" do
      table = table_fixture()
      assert {:ok, %Table{}} = Formats.delete_table(table)
      assert_raise Ecto.NoResultsError, fn -> Formats.get_table!(table.id) end
    end

    test "change_table/1 returns a table changeset" do
      table = table_fixture()
      assert %Ecto.Changeset{} = Formats.change_table(table)
    end
  end
end
