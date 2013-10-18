class API < Grape::API
  prefix 'api'
  version 'v1', using: :path
  format :json

  get do
    { message: "You've reached the API root page!" }
  end

  resource :apps do

    get do
      { message: "You must specify an app name!" }
    end

    desc "Return a app's address given the app's name."
    params do
      requires :id, type: String, desc: "App name."
    end
    route_param :id do
      get do
        a = App.find_by name: params[:id]
        return {name: a.name,
                address: a.address}
      end
    end

    #desc "Create an app association."
    #params do
    #  requires :name, type: String, desc: "Name of app."
    #  requires :address, type: String, desc: "Address of app."
    #end
    #post do
    #  App.create!({
    #    name: params[:name],
    #    address: params[:address]
    #  })
    #end

    #desc "Delete an app."
    #params do
    #  requires :id, type: String, desc: "Status ID."
    #end
    #delete ':id' do
    #  authenticate!
    #  current_user.statuses.find(params[:id]).destroy
    #end

  end
end
