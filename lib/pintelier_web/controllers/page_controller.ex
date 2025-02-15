defmodule PintelierWeb.PageController do
  use PintelierWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:consumptions, Pintelier.Drinking.list_global_consumptions())
    |> render(:home)
  end
end
