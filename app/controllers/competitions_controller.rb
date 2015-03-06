class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show, :edit, :update, :destroy, :next_state,
                                         :start_all, :start, :start_plus_one, :mark_dns, :mark_dnf,
                                         :mark_complete, :update_result]
  before_action :set_competitor, only: [:start, :start_plus_one, :mark_dns, :mark_dnf,
                                         :mark_complete, :update_result]
  before_action :authenticate_user!, except: [:show, :index, :print]

  
  def print
    @print = true
    index
  end
  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.all.order_by(order_number: :asc)
    respond_to do |format|
      format.html do
        @total_competitors = @competitions.inject(0){|sum,x| sum + (x[:list].nil? ? 0 : x[:list].length) }
        render :index
      end
      format.json { render json: @competitions.as_json }
    end
  end
  
  def numbers
    check_admin
    result = update_numbers(params)
    respond_to do |format|
      format.html { redirect_to competitions_path, notice: result }
      format.json { render :show, status: :created, location: @competition }
    end
  end
  
  def next_state
    puts "changing state from #{@competition.state} to #{@competition.next_state}"
    @competition.next_state!
    puts "state is now #{Competition.find(params[:id]).state}"
    respond_to do |format|
      format.html { redirect_to competitions_path, notice: "State changed to #{@competition.state}" }
      format.json { render :show, status: :created, location: @competition }
    end
  end
  
  def organize
    check_admin
    results = perform_reorganization
    if results.blank?
      notice = "Competition reorganization done, no change!"
    else
      notice = results.slice(0,10).join("<br/>").html_safe
    end
    notice += "<br/>... and more" if results.length > 11

    respond_to do |format|
      format.html { redirect_to competitions_path, notice: notice }
      format.json { render :show, status: :created, location: @competition }
    end
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @competition.as_json }
    end
  end

  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions
  # POST /competitions.json
  def create
    check_admin
    @competition = Competition.new(competition_params)

    respond_to do |format|
      if @competition.save
        format.html { redirect_to competitions_path, notice: 'Competition was successfully created.' }
        format.json { render :show, status: :created, location: @competition }
      else
        format.html { render :new }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    check_admin
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to competitions_path, notice: 'Competition was successfully updated.' }
        format.json { render :show, status: :ok, location: @competition }
      else
        format.html { render :edit }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    check_admin
    @competition.destroy
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: 'Competition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def start_all
    check_admin
    puts "Starting all for competition #{@competition.name} on day #{params[:day]}"
    @competition.start_all!(params[:day].to_i)
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "Mass start in #{@competition.name}." }
      format.json { head :no_content }
    end
  end
  
  def start
    check_admin
    puts "Starting #{@competitor[:name]} for competition #{@competition.name} on day #{params[:day]}"
    @competition.start! @competitor, params[:day].to_i, nil
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "#{@competitor[:name]} started in #{@competition.name}." }
      format.json { head :no_content }
    end
  end

  def start_plus_one
    check_admin
    puts "Starting after a minute #{@competitor[:name]} for competition #{@competition.name} on day #{params[:day]}"
    @competition.start_plus_one! @competitor, params[:day].to_i
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "#{@competitor[:name]} started in #{@competition.name} one minute after previous." }
      format.json { head :no_content }
    end
  end

  def mark_dns
    check_admin
    puts "#{@competitor[:name]} marked :dns in #{@competition.name}."
    @competition.mark_dns! @competitor, params[:day].to_i
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "#{@competitor[:name]} marked :dns in #{@competition.name}." }
      format.json { head :no_content }
    end
  end
  def mark_dnf
    check_admin
    puts "#{@competitor[:name]} marked :dnf in #{@competition.name}."
    @competition.mark_dnf! @competitor, params[:day].to_i
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "#{@competitor[:name]} marked :dnf in #{@competition.name}." }
      format.json { head :no_content }
    end
  end
  def mark_complete
    check_admin
    puts "#{@competitor[:name]} passed through FINISH #{@competition.name}."
    @competition.mark_complete! @competitor, params[:day].to_i
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "#{@competitor[:name]} passed through FINISH #{@competition.name}." }
      format.json { head :no_content }
    end
  end
  def update_result
    check_admin
    @competition.update_result! @competitor, params[:new_status], params[:day].to_i
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "#{@competitor[:name]} updated status to #{params[:new_status]}" }
      format.json { head :no_content }
    end
  end
private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end
    
    def set_competitor
      @competitor = @competition[:list].select{ |c| c[:id].to_s == params[:userid]}[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:competition).permit(:code, :name, :type, :order_number, :state)
    end
    
    def to_new_code(maybe_old_code)
        maybe_old_code
          .gsub(" SM", "")
          .gsub("NMS1", "SM1 ")
          .gsub("NWS1", "SW1 ")
          .gsub("Veteraani Miehet", "SM1 veteraani")
          .gsub("Veteraani Naiset", "SW1 veteraani")
          .gsub("NMSJ A/B", "SMj B")
    end
    
    def perform_reorganization
      results = []
      # first, go through competitions and competitors, and check that each should be in the application
      Competition.each do |competition|
        if competition[:list] and competition[:list].reject! { |competitor|
              begin
                res = User.find(competitor[:id])[:races].none? {|r| to_new_code(r).gsub("SM ","") == competition.code.gsub("SM ","")} 
                results << "Removing #{competitor[:name]} from #{competition[:code]}" if res
                res
              rescue
                results << "Removing deleted user #{competitor[:name]} from #{competition[:code]}"
                true
              end
            }
          Competition.collection.find(_id: competition._id).update("$set" => { list: competition[:list]})
        end
      end
      # second, go through all the users and their applied for races, and add them if they are not already added
      User.all.each do |user| user[:races].each do |c|
          competition = begin Competition.find_by(code: to_new_code(c)) rescue Competition.find_by(code: "SM #{to_new_code(c)}") end
          if competition[:list].none? {|cc| cc[:id] == user.id}
            results << "Adding #{user[:name].titleize} to #{competition.code}"
            competition[:list] << {
              id: user.id,
              num: (competition[:list].map{|x| x[:num]}.max or 0) + 1,
              name: user.name,
              club: user.club,
              dogs: user[:dogs],
            }
            Competition.collection.find(_id: competition._id).update("$set" => { list: competition[:list]})
          end
        end
      end
      results
    end
    
    def update_numbers(data)
      result = 0
      data.each do |key, value| 
        unless (ident = key.split("$")).blank? or ident[0] != "number"
          competition = Competition.find_by(code: ident[1])
          changed = false
          competition[:list].map do |competitor|
            if competitor[:id].to_s == ident[2].to_s
              if competitor[:num].to_i != value.to_i
                puts "Changing #{competitor[:name]} in #{competition[:code]} from #{competitor[:num]} to #{value}"
                competitor[:num] = value.to_i
                result += 1
                changed = true
              end
            end
            competitor
          end
          if changed
            #following will sort the list by start number and save it
            competition.save_info!
          end
        end
      end
      "Changed #{result} numbers."
    end
end
