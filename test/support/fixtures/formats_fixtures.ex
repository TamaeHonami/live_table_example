defmodule LiveTableExample.FormatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveTableExample.Formats` context.
  """

  @doc """
  Generate a table.
  """
  def table_fixture(attrs \\ %{}) do
    {:ok, table} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> LiveTableExample.Formats.create_table()

    table
  end
end
