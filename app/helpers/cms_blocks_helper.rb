module CmsBlocksHelper
  def cms_blocks_path format
    @cms_block.new_record? ? cms_block_index_path : cms_block_path(@cms_block.id)
  end
end
