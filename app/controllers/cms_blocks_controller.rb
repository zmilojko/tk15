class CmsBlocksController < ApplicationController
  before_action :set_cms_block, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :show

  # GET /cms_blocks
  # GET /cms_blocks.json
  def index
    @cms_blocks = CmsBlock.all
  end

  # GET /cms_blocks/1
  # GET /cms_blocks/1.json
  def show
  end

  # GET /cms_blocks/new
  def new
    @cms_block = CmsBlock.new
  end

  # GET /cms_blocks/1/edit
  def edit
  end

  # POST /cms_blocks
  # POST /cms_blocks.json
  def create
    check_admin
    @cms_block = CmsBlock.new(cms_block_params)

    respond_to do |format|
      if @cms_block.save
        format.html { redirect_to @cms_block, notice: 'Cms block was successfully created.' }
        format.json { render :show, status: :created, location: @cms_block }
      else
        format.html { render :new }
        format.json { render json: @cms_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms_blocks/1
  # PATCH/PUT /cms_blocks/1.json
  def update
    check_admin
    respond_to do |format|
      if @cms_block.update(cms_block_params)
        format.html { redirect_to @cms_block, notice: 'Cms block was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_block }
      else
        format.html { render :edit }
        format.json { render json: @cms_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms_blocks/1
  # DELETE /cms_blocks/1.json
  def destroy
    check_admin
    @cms_block.destroy
    respond_to do |format|
      format.html { redirect_to cms_blocks_url, notice: 'Cms block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_cms_block
      # try to find the block by name and then by id
      puts "Searching for #{params[:id]}"
      @cms_block = CmsBlock.where(name: params[:id])[0] 
      @cms_block ||= CmsBlock.find(params[:id])
      puts "Found: #{@cms_block}"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_block_params
      params.require(:cms_block).permit(:name, :content)
    end
end
