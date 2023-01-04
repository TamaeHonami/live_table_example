defmodule LiveTableExample.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables) do
      add :title, :string

      timestamps()
    end
  end
end
