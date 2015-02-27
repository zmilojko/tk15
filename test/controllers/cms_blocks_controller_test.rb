require 'test_helper'

class CmsBlocksControllerTest < ActionController::TestCase
  setup do
    @cms_block = cms_blocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cms_blocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cms_block" do
    assert_difference('CmsBlock.count') do
      post :create, cms_block: { content: @cms_block.content, name: @cms_block.name }
    end

    assert_redirected_to cms_block_path(assigns(:cms_block))
  end

  test "should show cms_block" do
    get :show, id: @cms_block
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cms_block
    assert_response :success
  end

  test "should update cms_block" do
    patch :update, id: @cms_block, cms_block: { content: @cms_block.content, name: @cms_block.name }
    assert_redirected_to cms_block_path(assigns(:cms_block))
  end

  test "should destroy cms_block" do
    assert_difference('CmsBlock.count', -1) do
      delete :destroy, id: @cms_block
    end

    assert_redirected_to cms_blocks_path
  end
end
