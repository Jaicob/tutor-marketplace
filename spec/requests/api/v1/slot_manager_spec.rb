describe "SlotManager endpoints" do 
  let(:slot_manager) { create(:slot_manager) }

  it "Returns all SlotManagers" do 
    create_list(:slot_manager, 10)
    get "/api/v1/slot_managers"
    expect(response).to be_success
    expect(json.length).to eq(10)
  end

  # it "Returns all TutorCourses" do
  #   create_list(:tutor_course, 10)
  #   get "/api/v1/tutor_courses"
  #   expect(response).to be_success
  #   expect(json.length).to eq(10)
  # end

  # it "Returns a specific TutorCourse" do 
  #   get "/api/v1/tutor_courses/#{tutor_course.id}"
  #   expect(response).to be_success
  #   expect(json['id']).to eq(tutor_course.id)
  # end

  # it "Updates a specific TutorCourse's attributes" do 
  #   skip
  # end

end


#     resource :slot_managers do 
#       desc "Returns all slot_managers"
#       get do 
#         SlotManager.all
#       end

#       desc "Returns a specific slot"
#       get ":id" do 
#         slot_manager
#       end

#       desc "Updates a specific slot"
#       patch ":id" do
#         @slot_manager = slot_manager
#         if @slot_manager.update_attributes(declared_params)
#           return @slot_manager
#         else
#           return "Slot manager could not be saved: #{@slot_manager.errors.full_messages}"
#         end
#       end

#     end   # End of resource: slot_managers

#     resource :tutors do
#       segment "/:tutor_id" do
#         resource :slot_managers do 


#           desc "Returns all slot_managers for a tutor"
#           get do 
#             tutor.slot_managers
#           end

#           desc "Returns a specific slot_manager for a tutor"
#           get ":id" do 
#             slot_manager
#           end

#           desc "Creates a single slot_manager for a tutor" 
#           post do
#             @slot_manager = SlotManager.create(declared_params)
#             if @slot_manager.save
#               return @slot_manager
#             else
#               return "Slot manager could not be saved: #{@slot_manager.errors.full_messages}"
#             end
#           end

# desc "Creates a re-occuring slot for a tutor"
# post "/regular" do
# slot = Slot.new
# end

#     # Updates with PATCH
#     desc "Updates a slot_manager for a tutor"
#     patch ":id" do
#       @slot_manager = slot_manager
#       @slot_manager.update_attributes(declared_params)
      
#       if @slot_manager.save
#         return @slot_manager
#       else
#         return "Slot manager could not be updated: #{@slot_manager.errors.full_messages}"
#       end
#     end

#     # Updates with PUT
#     desc "Updates a slot_manager for a tutor"
#     put ":id" do
#       @slot_manager = slot_manager
#       @slot_manager.update_attributes(declared_params)

#       if @slot_manager.save
#         return @slot_manager
#       else
#         return "Slot manager could not be updated: #{@slot_manager.errors.full_messages}"
#       end
#     end

#     desc "Deletes a slot_manager for a tutor"
#     delete ":id" do 
#       @slot_manager = slot_manager

#       if @slot_manager.destroy
#         return "Slot manager was succesfully deleted."
#       else
#         return "Slot manager was not deleted: #{@slot_manager.errors.full_messages}"
#       end
#     end


#   # This section is for endpoints that target the slots in a slot_manager
#   segment "/:id" do
#     resource :slots do 

#       desc "Returns all of a slot managers' slots"
#       get do 
#         slot_manager.slots
#       end

#       desc "Updates all of a slot_manager's slots"
#       put do
#         safe_params = {
#           end_time: params[:end_time]
#         }
#         slot_manager.update_all_slots(safe_params)
#       end

#       desc "Updates all of a slot_manager's slots"
#       patch do
#         safe_params = {
#           end_time: params[:end_time]
#         }
#         slot_manager.update_all_slots(safe_params)
