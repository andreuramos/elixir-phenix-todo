defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :text, :string
      add :person_id, :integer
      add :status, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
