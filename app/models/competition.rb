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
  end
  
  def competitor_position(competitor)
    self[:list].find_index {|c| c == competitor} + 1
  end

  def competitor_score(competitor)
    
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
    self[:list].each { |competitor| start competitor, day, nil }
    save_info!
  end
  def start!(competitor, day, timestamp)
    start competitor, day, timestamp
    save_info!
  end
  def can_start_plus_one!(competitor, day)
    if type == "two runs combined"
      index = day - 1
    else
      index = 0
    end
    begin
      (self[:list].select {|c| c[:num] == competitor[:num] - 1}[0][:result][index][:status]) == :started
    rescue
      false
    end
  end
  def start_plus_one!(competitor, day)
    if type == "two runs combined"
      index = day - 1
    else
      index = 0
    end
    start! competitor, day, self[:list].select {|c| c[:num] == competitor[:num] - 1}[0][:result][index][:start_time]
  end
  def final_result(competitor)
    provisional_result(competitor)
  end
  def save_info!
    sort!
    Competition.collection.find(_id: _id).update("$set" => { list: self[:list]})
  end
  def compare(c1, c2, only_first_day: false)
    if compare_provisional_results(provisional_result(c1,only_first_day: only_first_day, comapring: true), 
                                   provisional_result(c2,only_first_day: only_first_day, comapring: true)) == 0
      # compare by start number, unless both have started
      unless provisional_result(c1,only_first_day: only_first_day, comapring: true) == :started
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
      compare_provisional_results(provisional_result(c1,only_first_day: only_first_day, comapring: true),
                                  provisional_result(c2,only_first_day: only_first_day, comapring: true))
    end
  end
  def mark_dns!(competitor, day)
    if type == "two runs combined"
      index = day - 1
      competitor[:result] ||= [new_info_hash,new_info_hash]
    else
      competitor[:result] ||= [new_info_hash]
      index = 0
    end
    competitor[:result][index][:status] = :dns
    competitor[:result][index][:start_time] = nil
    competitor[:result][index][:finish_time] = nil
    competitor[:result][index][:result_time] = nil
    if type == "two runs combined" and day == 1
      competitor[:result][1][:status] = :dns
      competitor[:result][1][:start_time] = nil
      competitor[:result][1][:finish_time] = nil
      competitor[:result][1][:result_time] = nil
    end
    save_info!
  end
  def mark_dnf!(competitor, day)
    if type == "two runs combined"
      index = day - 1
      competitor[:result] ||= [new_info_hash,new_info_hash]
    else
      competitor[:result] ||= [new_info_hash]
      index = 0
    end
    competitor[:result][index][:status] = :dnf
    competitor[:result][index][:finish_time] = nil
    competitor[:result][index][:result_time] = nil
    if type == "two runs combined" and day == 1
      competitor[:result][1][:status] = :dns
      competitor[:result][1][:start_time] = nil
      competitor[:result][1][:finish_time] = nil
      competitor[:result][1][:result_time] = nil
    end
    save_info!
  end
  def mark_complete!(competitor, day)
    if type == "two runs combined"
      index = day - 1
    else
      index = 0
    end
    competitor[:result][index][:status] = :completed
    competitor[:result][index][:finish_time] = Time.now
    timediff = competitor[:result][index][:finish_time] - competitor[:result][index][:start_time]
    competitor[:result][index][:result_time] = sprintf("%1d:%02d:%02d.%1d",timediff/60/60, timediff / 60 % 60, timediff % 60, timediff * 10 % 10 )
    save_info!
  end
  def update_result!(competitor, new_status, day)
    puts "UDPATING #{competitor[:name]} to #{new_status} on day #{day}"
    new_status.downcase!
    if type == "two runs combined"
      index = day - 1
      competitor[:result] ||= [new_info_hash,new_info_hash]
    else
      index = 0
      competitor[:result] ||= [new_info_hash]
    end
    if "started dns dnf none".split.include? new_status 
      competitor[:result][index][:status] = new_status.to_sym
    elsif is_time_string(new_status)
      competitor[:result][index][:status] = :completed
      competitor[:result][index][:result_time] = new_status
    end
    save_info!
  end

  def result(competitor, day)
    if type == "two runs combined" and day != 0
      if competitor[:result] and competitor[:result][day - 1] and competitor[:result][day - 1] != :none
        if competitor[:result][day - 1][:status] != :completed
          competitor[:result][day - 1][:status]
        else
          competitor[:result][0][:result_time]
        end
      else
        nil
      end
    else
      final_result competitor
    end
  end

  def is_time_string(s)
    if s.nil?
      false
    else
      s.to_s.match /\d:\d\d:\d\d.\d/
    end
  end

  def compare_provisional_results(p1,p2)
    if is_time_string(p1)
      is_time_string(p2) ? p1 <=> p2 : -1
    elsif is_time_string(p2)
      1
    elsif p1.nil?
      p2.nil? ? 0 :1
    elsif p2.nil?
      -1
    elsif p1.to_sym == :dns
      p2.to_sym == :dns ? 0 : 1
    elsif p2.to_sym == :dns
      -1
    elsif p1.to_sym == :dnf
      p2.to_sym == :dnf ? 0 : 1
    elsif p2.to_sym == :dnf
      -1
    elsif p1.to_sym == :started
      if p2.to_sym != :started
        -1
      else
        0
      end
    elsif p2.to_sym == :started
      1
    else
      throw "I forgot some possible state"
    end
  end
private
  def start(competitor, day, timestamp)
    timestamp ||= Time.now
    if type == "two runs combined"
      index = day - 1
      competitor[:result] ||= [new_info_hash,new_info_hash]
    else
      competitor[:result] ||= [new_info_hash]
      index = 0
    end
    competitor[:result][index] = {
      status: :started,
      start_time: timestamp || Time.now,
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
  def provisional_result(competitor,only_first_day: false, comapring: false)
    if type == "two runs combined" and not only_first_day
      if competitor[:result] and competitor[:result][1][:status] != :none
        if competitor[:result][1][:status] == :completed
          result = competitor[:result][0][:result_time] + competitor[:result][1][:result_time]
        else
          result = competitor[:result][1][:status]
        end
      else
        if competitor[:result] and competitor[:result][0][:status] != :none
          result = :started
        else
          result = nil
        end
      end
    else
      if competitor[:result] and competitor[:result][0][:status] != :none
        if competitor[:result][0][:status] == :completed
          result = competitor[:result][0][:result_time]
        else
          result = competitor[:result][0][:status]
        end
      else
        result = nil
      end
    end
    #puts "Provisional result for #{competitor[:name]} in #{name} #{"only for first day" if only_first_day} is #{result}"
    result
  end
end
