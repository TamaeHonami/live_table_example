defmodule LiveTableExample.Formats do
  @moduledoc """
  The Formats context.
  """

  import Ecto.Query, warn: false

  alias LiveTableExample.Repo
  alias LiveTableExample.Formats.Table
  alias LiveTableExample.Formats.Header
  alias LiveTableExample.Formats.Row
  alias LiveTableExample.Formats.Item

  @doc """
  Returns the list of tables.

  ## Examples

      iex> list_tables()
      [%Table{}, ...]

  """
  def list_tables do
    Repo.all(Table)
  end

  @doc """
  Gets a single table.

  Raises `Ecto.NoResultsError` if the Table does not exist.

  ## Examples

      iex> get_table!(123)
      %Table{}

      iex> get_table!(456)
      ** (Ecto.NoResultsError)

  """
  def get_table!(id) do
    Repo.get!(Table, id)
  end

  @doc """
  Creates a table.

  ## Examples

      iex> create_table(%{field: value})
      {:ok, %Table{}}

      iex> create_table(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_table(attrs \\ %{}) do
    %Table{}
    |> Table.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a table.

  ## Examples

      iex> update_table(table, %{field: new_value})
      {:ok, %Table{}}

      iex> update_table(table, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_table(%Table{} = table, attrs) do
    table
    |> Table.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a table.

  ## Examples

      iex> delete_table(table)
      {:ok, %Table{}}

      iex> delete_table(table)
      {:error, %Ecto.Changeset{}}

  """
  def delete_table(%Table{} = table) do
    Repo.delete(table)
  end

  @doc """
  Gets a single table with associate all data.
  """
  def get_table_with_detail(id) do
    query =
      from t in Table,
        where: t.id == ^id,
        left_join: h in assoc(t, :headers),
        left_join: r in assoc(t, :rows),
        left_join: i in assoc(r, :items),
        order_by: [
          asc: h.order,
          asc: r.order,
          asc: i.order
        ],
        preload: [
          headers: h,
          rows: {r, items: i}
        ]

    Repo.one(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.

  ## Examples

      iex> change_table(table)
      %Ecto.Changeset{data: %Table{}}

  """
  def change_table(%Table{} = table, attrs \\ %{}) do
    Table.changeset(table, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.

  ## Examples

      iex> change_header(header)
      %Ecto.Changeset{data: %Header{}}

  """
  def change_header(%Header{} = header, attrs \\ %{}) do
    Header.changeset(header, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.

  ## Examples

      iex> change_row(row)
      %Ecto.Changeset{data: %Row{}}

  """
  def change_row(%Row{} = row, attrs \\ %{}) do
    Row.changeset(row, attrs)
    |> cast_assoc_items()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.
  """
  def put_assoc_headers(%Ecto.Changeset{} = table, headers) do
    Ecto.Changeset.put_assoc(table, :headers, headers)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.
  """
  def put_assoc_rows(%Ecto.Changeset{} = table, rows) do
    Ecto.Changeset.put_assoc(table, :rows, rows)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.
  """
  def put_assoc_items(%Ecto.Changeset{} = row, items) do
    Ecto.Changeset.put_assoc(row, :items, items)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.
  """
  def cast_assoc_headers(%Ecto.Changeset{} = table) do
    Ecto.Changeset.cast_assoc(table, :headers, with: &change_header/2)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.
  """
  def cast_assoc_rows(%Ecto.Changeset{} = table) do
    Ecto.Changeset.cast_assoc(table, :rows, with: &change_row/2)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table changes.
  """
  def cast_assoc_items(%Ecto.Changeset{} = row) do
    Ecto.Changeset.cast_assoc(row, :items, with: &change_item/2)
  end
end
