#grape settings
module DokkuappCom
  class Application < Rails::Application
    config.paths.add "app/api", glob: "**/*.rb"
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]
  end
end
