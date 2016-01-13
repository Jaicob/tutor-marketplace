class TutorDestroyer

  def initialize(tutor)
    @tutor = tutor
  end

  def obliterate
    delete_all_files
    if @tutor.user.destroy
      response = {success: true}
    else
      response = {success: false, error: @tutor.errors.full_messages.first}
    end
    return response
  end

  def delete_all_files
    if @tutor.profile_pic.file
      @tutor.profile_pic.file.delete
    end

    if @tutor.profile_pic.thumb.file
      @tutor.profile_pic.thumb.file.delete
    end

    if @tutor.profile_pic.large.file
      @tutor.profile_pic.large.file.delete
    end

    if @tutor.transcript.file
      @tutor.transcript.file.delete
    end
  end

end