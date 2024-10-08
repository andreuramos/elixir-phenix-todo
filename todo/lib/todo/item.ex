defmodule Todo.Item do
  use Ecto.Schema
  alias Todo.Repo
  alias __MODULE__
  import Ecto.Changeset
  import Ecto.Query

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

  def create_item(attrs \\ %{}) do
    %Item{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_item!(id) do
    Repo.get!(Item, id)
  end

  def list_items do
    Item
    |> order_by(desc: :inserted_at)
    |> where([a], is_nil(a.status) or a.status != 2)
    |> Repo.all()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(id) do
    get_item!(id)
    |> Item.changeset(%{status: 2})
    |> Repo.update()  
  end

  def clear_completed() do
    completed_items = from(i in Item, where: i.status == 1)
    Repo.update_all(completed_items, set: [status: 2])
  end
end
