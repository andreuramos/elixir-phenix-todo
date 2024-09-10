defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:item) do
      add :text, :string
      add :person_id, :integer
      add :status, :integer, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
