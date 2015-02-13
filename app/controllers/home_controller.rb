class HomeController < ApplicationController
  def index
    render layout: false
  end
  
  # POST /apply {'name': 'zeljko', 'email': 'zeljko@zwr.fi', 'club': 'z-ware', 'races': ['sp4','sp4j'] }
  def apply
    a = params["home"]
    a["appnum"] = User.max(:appnum).to_i + 1
    a["admin"] = false
    puts  JSON.pretty_generate a
    data = params["receipt"]# code like this  data:image/png;base64,iVBORw0KGgoA...
    if params["receipt"].nil?
      render json: {reason: "Did you pay? You should upload the receipt!", status: 400}, status: 400
      return
    elsif params["receipt"].include? "application/pdf"
      file_type = "pdf"
      file_data = Base64.decode64(params["receipt"].gsub(/.+base64,/,""))
    elsif params["receipt"].include? "image/jpeg"
      file_type = "jpg"
      file_data = Base64.decode64(params["receipt"].gsub(/.+base64,/,""))
    else
      render json: {reason: "We only accept pdf and jgp. Please scan your receipt again.", status: 400}, status: 400
      return
    end
    a["receipt_file"] = "receipt#{a["appnum"]}"
    File.open(Rails.root.join("receipts", "#{a["receipt_file"]}.#{file_type}"), 'wb') do |f|
      f.write(file_data)
    end
    a.delete :receipt
    puts  JSON.pretty_generate a
    User.collection.insert(a)
    a = User.collection.find(appnum: a["appnum"]).first
    render json: { result: 'ok', application: a.as_json }
    puts  JSON.pretty_generate a.as_json
  end
end
