json.array!(@cms_blocks) do |cms_block|
  json.extract! cms_block, :id, :name, :content
  json.url cms_block_url(cms_block, format: :json)
end
