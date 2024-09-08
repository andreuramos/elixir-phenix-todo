defmodule TodoWeb.PageLiveTest do
    use TodoWeb.ConnCase
    import Phoenix.LiveViewTest

    test "disconnected and connected mount", %{conn: conn} do
        {:ok, page_live, disconnected_html} = live(conn, "/")

        assert disconnected_html =~ "todo"
        assert render(page_live) =~ "What needs to be done"
    end
end