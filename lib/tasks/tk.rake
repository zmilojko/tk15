namespace :tk do
  desc "clears all start lists"
  task clear_startlist: :environment do
    Competition.all.each do |c|
      c[:list] = []
      c.save!
    end
  end
  
  desc "populates competitions with applied competitors"
  task startlist: :environment do
    User.all.each do |user| user[:races].each do |c|
        c.gsub! " SM", ""
        c.gsub! "NMS1", "SM1 "
        c.gsub! "NWS1", "SW1 "
        c.gsub! "Veteraani Miehet", "SM1 veteraani"
        c.gsub! "Veteraani Naiset", "SW1 veteraani"
        c.gsub! "NMSJ A/B", "SMj B"
        competition = begin Competition.find_by(code: c) rescue Competition.find_by(code: "SM #{c}") end
        if competition[:list].none? {|cc| cc[:id] == user.id}
          puts "adding #{user[:name].titleize}: #{c}"
          competition[:list] << {
            id: user.id,
            num: (competition[:list].map{|x| x[:num]}.max or 0) + 1,
            name: user.name,
            club: user.club,
            dogs: user[:dogs],
          }
          Competition.collection.find(_id: competition._id).update("$set" => { list: competition[:list]})
        end
        #competition.save!
      end
    end
  end

  desc "removes emails from the competitor info"
  task clean_emails: :environment do
    Competition.each do |competition|
      if competition[:list]
        new_list = competition[:list].map {|c| c.delete('email'); c }
        Competition.collection.find(_id: competition._id).update("$set" => { list: new_list})
      end
    end
  end
end
