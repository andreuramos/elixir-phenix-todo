defmodule TodoWeb.PageLive do
    use TodoWeb, :live_view
    alias Todo.Item
    alias TodoWeb.Router.Helpers, as: Routes

    @topic "live"

    @impl true
    def mount(_params, _session, socket) do

        if connected?(socket), do: TodoWeb.Endpoint.subscribe(@topic)
        {:ok, assign(socket, items: Item.list_items(), editing: nil)}
    end

    @impl true
    def handle_event("create", %{"text" => text}, socket) do
        Item.create_item(%{text: text})
        socket = assign(socket, items: Item.list_items(), active: %Item{})
        TodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)

        {:noreply, socket}
    end

    @impl true
    def handle_event("toggle", data, socket) do
        status = if Map.has_key?(data, "value"), do: 1, else: 0
        item = Item.get_item!(Map.get(data, "id"))
        Item.update_item(item, %{id: item.id, status: status})

        socket = assign(socket, items: Item.list_items(), active: %Item{})
        TodoWeb.Endpoint.broadcast(@topic, "update", socket.assigns)

        {:noreply, socket}
    end

    @imple true
    def handle_event("delete", data, socket) do
        Item.delete_item(Map.get(data, "id"))

        socket = assign(socket, items: Item.list_items(), active: %Item{})
        TodoWeb.Endpoint.broadcast(@topic, "update", socket.assigns)

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
        TodoWeb.Endpoint.broadcast(@topic, "update", socket.assigns)

        {:noreply, socket}
    end

    @impl true
    def handle_info(%{event: "update", payload: %{items: items}}, socket) do
        {:noreply, assign(socket, items: items)}
    end

    @impl true
    def handle_params(params, _url, socket) do
        items = Item.list_items()

        case params["filter_by"] do
        "completed" ->
            completed = Enum.filter(items, &(&1.status == 1))
            {:noreply, assign(socket, items: completed, tab: "completed")}

        "active" ->
            active = Enum.filter(items, &(&1.status == 0))
            {:noreply, assign(socket, items: active, tab: "active")}

        _ ->
            {:noreply, assign(socket, items: items, tab: "all")}
        end
    end

    def checked?(%Item{} = item) do
        not is_nil(item.status) and item.status > 0
    end

    def completed?(%Item{} = item) do
        if not is_nil(item.status) and item.status > 0, do: "completed", else: ""
    end
end