defmodule LiveTableExample.Formats.Row do
  use Ecto.Schema
  import Ecto.Changeset

  schema "table_rows" do
    field :order, :integer
    belongs_to :table, LiveTableExample.Formats.Table
    has_many :items, LiveTableExample.Formats.Item

    timestamps()
  end

  @doc false
  def changeset(row, attrs) do
    row
    |> cast(attrs, [:order])
    |> validate_required([:order])
  end
end
