class ComplaintsController < ApplicationController
  def create
    @complaint = Complaint.new(complaint_params)
    if @complaint.save
      render json: { status: 'Success', data: @complaint }, status: :created
    else
      render json: { status: 'Error', message: @complaint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def complaint_params
    params.require(:complaint).permit(:content)
  end
end
