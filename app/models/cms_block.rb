class CmsBlock
  include Mongoid::Document
  field :name, type: String
  field :content, type: String
  
  def view
    MDParser.render(content).html_safe
  end
end
