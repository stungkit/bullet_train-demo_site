Rails.application.routes.draw do
  # See `config/routes/*.rb` to customize these configurations.
  draw "concerns"
  draw "devise"
  draw "sidekiq"

  # TODO Move this into a `draw "heroku"` helper from BT.
  constraints(:host => /herokuapp.com/) do
    match "/(*path)" => redirect {|params, req| "#{ENV['BASE_URL']}/#{params[:path]}"},  via: [:get, :post]
  end

  # `collection_actions` is automatically super scaffolded to your routes file when creating certain objects.
  # This is helpful to have around when working with shallow routes and complicated model namespacing. We don't use this
  # by default, but sometimes Super Scaffolding will generate routes that use this for `only` and `except` options.
  collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment

  # This helps mark `resources` definitions below as not actually defining the routes for a given resource, but just
  # making it possible for developers to extend definitions that are already defined by the `bullet_train` Ruby gem.
  # TODO Would love to get this out of the application routes file.
  extending = {only: []}

  scope module: "public" do
    # To keep things organized, we put non-authenticated controllers in the `Public::` namespace.
    # The root `/` path is routed to `Public::HomeController#index` by default.
  end

  namespace :webhooks do
    namespace :incoming do
      resources :bullet_train_webhooks
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth provider webhooks above this line.
      end
    end
  end

  namespace :api do
    draw "api/v1"
    # 🚅 super scaffolding will insert new api versions above this line.
  end

  namespace :account do
    shallow do
      # user-level onboarding tasks.
      namespace :onboarding do
        # routes for standard onboarding steps are configured in the `bullet_train` gem, but you can add more here.
      end

      # user specific resources.
      resources :users, extending do
        namespace :oauth do
          # 🚅 super scaffolding will insert new oauth providers above this line.
        end

        # routes for standard user actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      # team-level resources.
      resources :teams, extending do
        # routes for many teams actions and resources are configured in the `bullet_train` gem, but you can add more here.

        # add your resources here.

        resources :invitations, extending do
          # routes for standard invitation actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        resources :memberships, extending do
          # routes for standard membership actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        namespace :integrations do
          # 🚅 super scaffolding will insert new integration installations above this line.
        end
      end
    end
  end

  scope module: "public" do
    # We have to do these things manually for our demo site. The main `bullet_train` gem will automatically
    # set up these routes for non-production environments, so we only set them up if we ARE in prod.
    if Rails.env.production?
      mount Showcase::Engine, at: "/docs/showcase" if defined?(Showcase::Engine)
      get "docs", to: "home#docs"
      get "docs/*page", to: "home#docs"
    end
  end
end
