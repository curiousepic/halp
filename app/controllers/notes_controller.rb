class NotesController < ApplicationController
  def create
    @user = current_user
    @note = Note.new(note_params)
    if @note.save
      unless @user == @note.problem.user
        UserMailer.note_added(@user, @note).deliver
      end
    end
    respond_to do |format|
      format.html do
        if @note.save
          redirect_to problem_path(@note.problem_id), notice: "Note saved successfully"
        else
          redirect_to problem_path(@note.problem_id), notice: "Invalid note input"
        end
      end
      format.js do
        if @note.save
          render :add_note, status: :ok
        else
          redirect_to problem_path(@note.problem_id), notice: "Invalid note input"
        end
      end
    end
  end

  private

  def note_params
    params.require(:note).permit(:user_id, :problem_id, :text )
  end
end
