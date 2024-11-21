class CompaniesController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_company, only: [:show, :edit, :update, :destroy, :delegate, :delegate_user]

  # GET /companies or /companies.json
  def index
    if current_user.admin?
      @companies = Company.all
    else
      @companies = User.companies_with_role(current_user.id)
    end
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/:id/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    begin
      @company = Company.new(company_params)
      @company.transaction do
        @company.save!
        Role.create(
          user_id: current_user.id,
          company_id: @company.id,
          role: Role::ROL_DELEGADO
        )
      end
      redirect_to @company, notice: 'La empresa fué creada exitosamente' 
    rescue => e
      render :new
    end    
  end

  # PATCH/PUT /companies/:id or /companies/:id.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'La empresa fué actualizada.' }
        format.json { render :index, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def company_params
    params.require(:company).permit(
      :name, :cuit, :address, :contact_name, :contact_phone, :contact_email, :estatuto_file,
      delegation: [:email]
    )
  end
end