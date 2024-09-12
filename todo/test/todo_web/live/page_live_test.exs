defmodule TodoWeb.PageLiveTest do
    use TodoWeb.ConnCase
    import Phoenix.LiveViewTest
    alias Todo.Item

    test "disconnected and connected mount", %{conn: conn} do
        {:ok, page_live, disconnected_html} = live(conn, "/")

        assert disconnected_html =~ "todo"
        assert render(page_live) =~ "What needs to be done"
    end

    test "connect and create a todo item", %{conn: conn} do
        {:ok, view, _html} = live(conn, "/")
        assert render_submit(view, :create, %{"text" => "Learn Elixir"}) =~ "Learn Elixir"
    end

    test "toggle an item", %{conn: conn} do
        {:ok, item} = Item.create_item(%{"text" => "Learn Elixir"})
        assert item.status == 0

        {:ok, view, _html} = live(conn, "/")
        assert render_click(view, :toggle, %{"id" => item.id, "value" => 1}) =~ "completed"

        updated_item = Item.get_item!(item.id)
        assert updated_item.status == 1
    end

    test "delete an item", %{conn: conn} do
        {:ok, item} = Item.create_item(%{"text" => "Learn Elixir"})
        assert item.status == 0

        {:ok, view, _html} = live(conn, "/")
        assert render_click(view, :delete, %{"id" => item.id})

        updated_item = Item.get_item!(item.id)
        assert updated_item.status == 2
    end

    test "edit item", %{conn: conn} do
        {:ok, item} = Item.create_item(%{"text" => "Test edit item"})

        {:ok, view, _html} = live(conn, "/")

        assert render_click(view, "edit-item", %{"id" => Integer.to_string(item.id)}) =~
             "<form phx-submit=\"update-item\" id=\"form-update\">"
    end

    test "update an item", %{conn: conn} do
        {:ok, item} = Item.create_item(%{"text" => "Test update items text"})

        {:ok, view, _html} = live(conn, "/")

        assert render_submit(view, "update-item", %{"id" => item.id, "text" => "updated text"}) =~
            "updated text"

        updated_item = Item.get_item!(item.id)
        assert updated_item.text == "updated text"
    end
end