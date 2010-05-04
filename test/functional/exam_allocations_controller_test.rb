require 'test_helper'

class ExamAllocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exam_allocations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exam_allocation" do
    assert_difference('ExamAllocation.count') do
      post :create, :exam_allocation => { }
    end

    assert_redirected_to exam_allocation_path(assigns(:exam_allocation))
  end

  test "should show exam_allocation" do
    get :show, :id => exam_allocations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => exam_allocations(:one).id
    assert_response :success
  end

  test "should update exam_allocation" do
    put :update, :id => exam_allocations(:one).id, :exam_allocation => { }
    assert_redirected_to exam_allocation_path(assigns(:exam_allocation))
  end

  test "should destroy exam_allocation" do
    assert_difference('ExamAllocation.count', -1) do
      delete :destroy, :id => exam_allocations(:one).id
    end

    assert_redirected_to exam_allocations_path
  end
end
