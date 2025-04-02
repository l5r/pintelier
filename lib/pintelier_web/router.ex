defmodule PintelierWeb.Router do
  use PintelierWeb, :router

  import PintelierWeb.UserAuth
  import Backpex.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PintelierWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PintelierWeb do
    pipe_through :browser

    live_session :maybe_current_user,
      on_mount: [{PintelierWeb.UserAuth, :mount_current_user}] do

    # TODO: make a home page
    live "/", FeedLive.Index, :index
    end
  end

  scope "/", PintelierWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :authenticated,
      on_mount: [{PintelierWeb.UserAuth, :ensure_authenticated}] do
      live "/feed", FeedLive.Index, :index
      live "/feed/new", FeedLive.Index, :new

      live "/consumptions", ConsumptionLive.Index, :index
      live "/consumptions/new", ConsumptionLive.Index, :new
      live "/consumptions/:id/edit", ConsumptionLive.Index, :edit
      live "/consumptions/:id", ConsumptionLive.Show, :show
      live "/consumptions/:id/show/edit", ConsumptionLive.Show, :edit

      scope "/groups" do
        live "/", GroupLive.Index, :index
        live "/new", GroupLive.Index, :new
        live "/:id/edit", GroupLive.Index, :edit
      end
    end
  end

  ## Admin routes

  scope "/admin", PintelierWeb do
    # TODO: authorization!
    pipe_through [:browser, :require_admin_user]

    backpex_routes()

    live_session :require_admin_user,
      on_mount: [{PintelierWeb.UserAuth, :ensure_admin_user},
      Backpex.InitAssigns] do
      
      live_resources "/drinks", Admin.DrinkLive
      live_resources "/users", Admin.UserLive
      live_resources "/consumptions", Admin.ConsumptionLive
      live_resources "/consumption_sessions", Admin.ConsumptionSessionLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PintelierWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pintelier, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PintelierWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PintelierWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PintelierWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PintelierWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PintelierWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", PintelierWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PintelierWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
