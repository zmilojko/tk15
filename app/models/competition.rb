class Competition
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  field :type, type: String
  field :order_number, type: Integer
  field :state, type: String
  
  # States: :open, :ready, :active, :done, :closed
  
  def next_state
    if not state
      :ready
    else
      case state.to_sym
      when :open
        :ready
      when :ready
        :active
      when :active
        :done
      when :done
        :closed
      when :closed
        nil
      end
    end      
  end
  
  def next_state!
    unless not next_state
      self.state = next_state
      save!
    else
      throw "Cannot change to next state"
    end
  end
end
