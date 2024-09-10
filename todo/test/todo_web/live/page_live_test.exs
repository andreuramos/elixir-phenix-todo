defmodule TodoWeb.PageLiveTest do
    use TodoWeb.ConnCase
    import Phoenix.LiveViewTest

    test "disconnected and connected mount", %{conn: conn} do
        {:ok, page_live, disconnected_html} = live(conn, "/")

        assert disconnected_html =~ "todo"
        assert render(page_live) =~ "What needs to be done"
    end

    test "connect and create a todo item", %{conn: conn} do
        {:ok, view, _html} = live(conn, "/")
        assert render_submit(view, :create, %{"text" => "Learn Elixir"}) =~ "Learn Elixir"
    end
end