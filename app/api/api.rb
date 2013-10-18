require 'resolv' #for validating IP address

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
      requires :name, type: String, desc: "Name of app."
    end
    route_param :name do
      get do
        a = App.find_by! name: params[:name]
        return {name: a.name,
                address: a.address}
      end
    end

    desc "Create an association between an app name and server address."
    params do
      requires :name, type: String, desc: "Name of app."
      optional :address, type: String, regexp: Resolv::IPv4::Regex, 
                         desc: "Address of app server."
    end
    post do
      a = App.find_or_initialize_by name: params[:name]
      #If no address is specified, use the address of the client.
      #request.remote_ip does not exist here so need to grab it from env.
      params[:address] = request.env['action_dispatch.remote_ip'].to_s if params[:address].nil?
      a.address = params[:address]
      a.save
      return {name: a.name,
              address: a.address}
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
