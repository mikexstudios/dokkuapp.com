class API < Grape::API
  prefix 'api'
  version 'v1', using: :path
  format :json

  resource :apps do

    desc "Return a app's address."
    params do
      requires :id, type: Integer, desc: "Status id."
    end
    route_param :id do
      get do
        App.find(params[:id])
      end
    end

    desc "Create an app association."
    params do
      requires :name, type: String, desc: "Name of app."
      requires :address, type: String, desc: "Address of app."
    end
    post do
      App.create!({
        name: params[:name],
        address: params[:address]
      })
    end

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
