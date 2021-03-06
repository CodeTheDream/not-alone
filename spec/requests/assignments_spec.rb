require 'rails_helper'

RSpec.describe "Assignments", type: :request do

  # describe "get assignments_index_path" do
  #   it "renders the index view" do
  #     customer = FactoryBot.create(:customer)
  #     assignments = FactoryBot.create_list(:assignment, 10)
  #     user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
  #     sign_in user
  #     get customer_assignments_path(customer_id: customer.id)
  #     expect(response.status).to render_template(:index)
  #   end
  # end

  describe "get assignment_path" do
    it "doesn't renders the :show template if not logged in" do
      assignment = FactoryBot.create(:assignment)
      get assignment_path(id: assignment.id)
      expect(response).to redirect_to(new_user_session_path)
    end
    it "renders the :show template" do
      assignment = FactoryBot.create(:assignment)
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      get assignment_path(id: assignment.id)
      expect(response).to render_template(:show)
    end
    it "renders the :show template - redirects to the index path if the assignment id is invalid" do
      assignment = FactoryBot.create(:assignment)
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      get assignment_path(id: 5000)
      expect(response).to redirect_to customers_path
    end
  end

  describe "get new_customer_assignment_path" do
    it "renders the :new template" do
      customer = FactoryBot.create(:customer)
      assignment = FactoryBot.create(:assignment)
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20",
        password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      get new_customer_assignment_path(customer_id: customer.id),
        params: {assignment: {status: "new"}}
      expect(response).to render_template(:new)
    end
  end

  describe "get new_customer_assignment_path" do
    it "renders the :new template - redirects to the index path if the the user role is invalid" do
      customer = FactoryBot.create(:customer)
      assignment = FactoryBot.create(:assignment)
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "stranger")
      sign_in user
      get new_customer_assignment_path(customer_id: customer.id, assignment_id: assignment.id)
      # expect(response.status).to eq(404)
      expect(response).to redirect_to home_index_path
    end
  end

  describe "get edit_assignment_path" do
    it "renders the :edit template" do
      assignment = FactoryBot.create(:assignment)
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      get edit_assignment_path(id: assignment.id)
      expect(response).to render_template(:edit)
    end
    it "renders the :edit template - redirects to the index path if the assignment id is invalid" do
      assignment = FactoryBot.create(:assignment)
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      get assignment_path(id: 5000)
      expect(response).to redirect_to customers_path
    end
  end

  describe "post assignments_path with valid data" do
    it "saves a new entry and redirects to the show path for the assignment" do
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      customer = FactoryBot.create(:customer)
      expect { post customer_assignments_path(customer_id: customer.id), params: {assignment: {user_id: user.id, status: "new"}}
    }.to change(Assignment, :count)
      expect(response).to redirect_to assignment_path(id: Assignment.last.id)
    end
  end

  describe "post assignments_path with invalid data" do
    it "does not save a new entry and redirects to the new path for the assignment" do
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      customer = FactoryBot.create(:customer)
      expect { post customer_assignments_path(customer_id: customer.id), params: {assignment: {status: "new"}}
        }.to_not change(Assignment, :count)
      expect(response).to render_template(:edit)
    end
  end

  describe "put assignment_path with valid data" do
    it "updates an entry and redirects to the show path for the assignment" do
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      customer = FactoryBot.create(:customer)
      assignment = FactoryBot.create(:assignment)
      put assignment_path(id: assignment.id), params: {assignment: {customer_id: customer.id, user_id: user.id, status: "new"}}
      assignment.reload
      expect(assignment.customer_id).to eq(customer.id)
      expect(assignment.user_id).to eq(user.id)
      expect(assignment.status).to eq("new")
      expect(response).to redirect_to assignment_path(id: assignment.id)
    end
  end

  describe "put assignment_path with invalid data" do
    it "updates an entry and redirects to the edit path for the assignment" do
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      customer = FactoryBot.create(:customer)
      assignment = FactoryBot.create(:assignment)
      put assignment_path(id: assignment.id), params: {assignment: {user_id: nil, status: ""}}
      assignment.reload
      expect(assignment.customer_id).not_to eq(nil)
      expect(assignment.user_id).not_to eq(nil)
      expect(assignment.status).not_to eq("")
      expect(response).to render_template(:edit)
    end
  end

  describe "delete a assignment record" do
    it "deletes a assignment record and redirects to the index path" do
      user = User.create(email: 'test@icloud.com', password: "Pa$$word20", password_confirmation: "Pa$$word20", role: "administrator")
      sign_in user
      customer = FactoryBot.create(:customer)
      assignment = FactoryBot.create(:assignment)
      customer = assignment.customer
      # delete assignment_path(id: assignment.id)
      # expect(response).to redirect_to customer
      expect {delete assignment_path(id: assignment.id)}.to change(Assignment, :count)
      expect(response).to redirect_to customer
     end
  end
end
