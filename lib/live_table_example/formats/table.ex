defmodule LiveTableExample.Formats.Table do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tables" do
    field :title, :string
    has_many :headers, LiveTableExample.Formats.Header
    has_many :rows, LiveTableExample.Formats.Row

    timestamps()
  end

  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
