class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.all.order_by(order_number: :asc)
    @total_competitors = @competitions.inject(0){|sum,x| sum + x[:list].length }
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @competitions.as_json }
    end
  end
  
  def organize
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
        format.html { redirect_to @competition, notice: 'Competition was successfully created.' }
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
        format.html { redirect_to @competition, notice: 'Competition was successfully updated.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:competition).permit(:code, :name, :type, :order_number)
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
        if competition[:list].reject! { |competitor| 
              res = User.find(competitor[:id])[:races].none? {|r| to_new_code(r).gsub("SM ","") == competition.code.gsub("SM ","")} 
              results << "Removing #{competitor[:name]} from #{competition[:code]}" if res
              res
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
              email: user.email,
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
end
