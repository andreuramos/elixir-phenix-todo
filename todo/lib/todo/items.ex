defmodule Todo.Items do
  use Ecto.Schema
  alias Todo.Repo
  alias __MODULE__
  import Ecto.Changeset

  schema "items" do
    field :status, :integer, default: 0
    field :text, :string
    field :person_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(items, attrs) do
    items
    |> cast(attrs, [:text, :person_id, :status])
    |> validate_required([:text])
  end
end
