class Competition
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  field :type, type: String
end
