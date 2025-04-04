defmodule PintelierWeb.InvitationController do
	use PintelierWeb, :controller

	alias Pintelier.Groups

	def accept(conn, %{"id" => id}) do
	  invitation = Groups.get_invitation!(id)
	  user = conn.assigns[:current_user]
    {:ok, _} = Groups.accept_invitation(user, invitation)
    conn
    |> redirect(to: ~p"/groups/#{invitation.group}")
    |> halt()
  end
end
