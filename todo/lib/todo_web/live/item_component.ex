defmodule TodoWeb.ItemComponent do
    use TodoWeb, :live_component
    alias Todo.Item

    @topic "live"

    attr(:items, :list, default: [])

    def render(assigns) do
        ~H"""
        <ul class="todo-list">
            <%= for item <- @items do %>
                <%= if item.status != 2 do %>
                    <%= if item.id == @editing do %>
                        <form phx-submit="update-item" id="form-update" phx-target={@myself}>
                            <input
                                id="update_todo"
                                class="new-todo"
                                type="text"
                                name="text"
                                required="required"
                                phx-hook="FocusInputItem"
                                value={item.text}
                            />
                            <input type="hidden" name="id" value={item.id}/>
                        </form>
                    <% else %>
                        <li data-id={item.id} class={completed?(item)}>
                            <div class="view">
                                <input
                                    class="toggle"
                                    type="checkbox"
                                    phx-value-id={item.id}
                                    phx-click="toggle"
                                    checked={checked?(item)}
                                    phx-target={@myself}
                                    id={"item-#{item.id}"}
                                />
                                <label
                                    phx-click="edit-item"
                                    phx-value-id={item.id}
                                    phx-target={@myself}
                                    id={"edit-item-#{item.id}"}
                                >
                                    <%= item.text %>
                                </label>                                
                                <button
                                    class="destroy"
                                    phx-click="delete"
                                    phx-value-id={item.id}
                                    phx-target={@myself}
                                    id={"delete-item-#{item.id}"}
                                >
                                </button>
                            </div>
                        </li>
                    <% end %>
                <% end %>
            <% end %>
        </ul>
        """
    end

    @impl true
    def handle_event("toggle", data, socket) do
        status = if Map.has_key?(data, "value"), do: 1, else: 0
        item = Item.get_item!(Map.get(data, "id"))
        Item.update_item(item, %{id: item.id, status: status})

        socket = assign(socket, items: Item.list_items(), active: %Item{})
        TodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)

        {:noreply, socket}
    end

    @imple true
    def handle_event("delete", data, socket) do
        Item.delete_item(Map.get(data, "id"))

        socket = assign(socket, items: Item.list_items(), active: %Item{})
        TodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)

        {:noreply, socket}
    end

    @impl true
    def handle_event("edit-item", data, socket) do
        {:noreply, assign(socket, editing: String.to_integer(data["id"]))}
    end

    @impl true
    def handle_event("update-item", %{"id" => item_id, "text" => text}, socket) do
        current_item = Item.get_item!(item_id)
        Item.update_item(current_item, %{text: text})
        items = Item.list_items()

        socket = assign(socket, items: items, editing: nil)
        TodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)

        {:noreply, socket}
    end

    def checked?(%Item{} = item) do
        not is_nil(item.status) and item.status > 0
    end

    def completed?(%Item{} = item) do
        if not is_nil(item.status) and item.status > 0, do: "completed", else: ""
    end
end