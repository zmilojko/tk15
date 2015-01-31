class HomeController < ApplicationController
  def index
    render layout: false
  end
  
  # POST /apply {'name': 'zeljko', 'email': 'zeljko@zwr.fi', 'club': 'z-ware', 'races': ['sp4','sp4j'] }
  def apply
    a = params["home"]
    a["appnum"] = User.max(:appnum).to_i + 1
    puts  JSON.pretty_generate a
    User.delete_all
    User.collection.insert(a)
    a = User.collection.find(appnum: a["appnum"]).first
    render json: { result: 'ok', application: a.as_json }
    puts  JSON.pretty_generate a.as_json
  end
end
