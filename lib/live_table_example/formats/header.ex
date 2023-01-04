defmodule LiveTableExample.Formats.Header do
  use Ecto.Schema
  import Ecto.Changeset

  schema "table_headers" do
    field :label, :string
    field :order, :integer
    belongs_to :table, LiveTableExample.Formats.Table

    timestamps()
  end

  @doc false
  def changeset(header, attrs) do
    header
    |> cast(attrs, [:label, :order])
    |> validate_required([:label, :order])
  end
end
