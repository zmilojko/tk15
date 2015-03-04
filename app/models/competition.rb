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
  
  def had_started
    state.to_sym == :active or
      state.to_sym == :done or
      state.to_sym == :closed
  end

  def sort!
    self[:list].sort! { |c1,c2| self.compare c1, c2 }
    save_info!
  end
  
  def competitor_position(competitor)
    self.sort!
    self[:list].find_index {|c| c == competitor} + 1
  end

  def competitor_score(competitor)
    'score'
  end
  def current_run_info(competitor, day)
    if type == "two runs combined"
      if competitor[:result].nil?
        competitor[:result] = [new_info_hash, new_info_hash]
      end
      competitor[:result][day-1]
    else
      if competitor[:result].nil?
        competitor[:result] = [new_info_hash]
      end
      competitor[:result][0]
    end
  end
  def start_all!( day)
    self[:list].each { |competitor| start competition, competitor, day }
    save_info!
  end
  def start!(competitor, day, timestamp)
    start competitor, day, timestamp
    save_info!
  end
  def start_plus_one!(competitor, day)
    if type == "two runs combined"
      index = day - 1
    else
      index = 0
    end
    start! competitor, day, self[:list].select {|c| c[:num] = competitor[:num] - 1}[0][:result][index][:start_time]
  end
  def final_result(competitor)
    provisional_result(competitor)
  end
  def save_info!
    Competition.collection.find(_id: _id).update("$set" => { list: self[:list]})
  end
  def compare(c1, c2, only_first_day: false)
    if provisional_result(c1,only_first_day: only_first_day) == provisional_result(c2,only_first_day: only_first_day)
      # compare by start number, unless both have started
      unless provisional_result(c1,only_first_day: only_first_day) == :started
        c1[:num].to_i <=> c2[:num].to_i
      else
        if type == "two runs combined" and not only_first_day
          if c1[:result][1][:start_time] or c2[:result][1][:start_time]
            (c1[:result][1][:start_time] or 10.years.ago) <=> (c1[:result][1][:start_time] or 10.years.ago)
          else
            self.compare c1, c2, only_first_day: true
          end
        else
          c1[:result][0][:start_time] <=> c2[:result][0][:start_time]
        end
      end
    else
      provisional_result(c1,only_first_day: only_first_day) <=> provisional_result(c2,only_first_day: only_first_day)
    end
  end
private
  def start(competitor, day, timestamp)
    timestamp = DateTime.now unless timestamp
    if type == "two runs combined"
      index = day - 1
    else
      index = 0
    end
    competitor[:result][index] = {
      status: :started,
      start_time: timestamp || DateTime.now,
      finish_time: nil,
      result_time: nil
    }
  end
  def new_info_hash
    {
      status: :none,
      start_time: nil,
      finish_time: nil,
      result_time: nil
    }
  end
  def provisional_result(competitor,only_first_day: false)
    if type == "two runs combined" and not only_first_day
      if competitor[:result] and competitor[:result][1][:status] != :none
        if competitor[:result][1][:status] == :completed
          competitor[:result][0][:result_time] + competitor[:result][1][:result_time]
        else
          competitor[:result][1][:status]
        end
      else
        if competitor[:result] and competitor[:result][0][:status] != :none
          :started
        else
          nil
        end
      end
    else
      if competitor[:result] and competitor[:result][0][:status] != :none
        if competitor[:result][0][:status] == :completed
          competitor[:result][0][:result_time]
        else
          competitor[:result][0][:status]
        end
      else
        nil
      end
    end
  end
end
