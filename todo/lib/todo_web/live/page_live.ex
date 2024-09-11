defmodule TodoWeb.PageLive do
    use TodoWeb, :live_view
    alias Todo.Item

    @topic "live"

    @impl true
    def mount(_params, _session, socket) do

        if connected?(socket), do: TodoWeb.Endpoint.subscribe(@topic)
        {:ok, assign(socket, items: Item.list_items())}
    end

    @impl true
    def handle_event("create", %{"text" => text}, socket) do
        Item.create_item(%{text: text})
        socket = assign(socket, items: Item.list_items(), active: %Item{})
        TodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)

        {:noreply, socket}
    end

    @impl true
    def handle_info(%{event: "update", payload: %{items: items}}, socket) do
        {:noreply, assign(socket, items: items)}
    end

    def checked?(%Item{} = item) do
        not is_nil(item.status) and item.status > 0
    end

    def completed?(%Item{} = item) do
        if not is_nil(item.status) and item.status > 0, do: "completed", else: ""
    end
end