defmodule LiveTableExample.Repo.Migrations.CreateTableItems do
  use Ecto.Migration

  def change do
    create table(:table_items) do
      add :context, :text
      add :order, :integer, null: false
      add :row_id, references(:table_rows, on_delete: :delete_all)

      timestamps()
    end

    create index(:table_items, [:row_id])
  end
end
