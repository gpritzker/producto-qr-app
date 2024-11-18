class CompaniesController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_company, only: [:show, :edit, :update, :destroy, :delegate, :delegate_user]

  # GET /companies or /companies.json
  def index
    if current_user.admin?
      @companies = Company.all
      @apoderado_companies = nil
      @supervisor_companies = nil
    else
      @companies = current_user.companies
      @apoderado_companies = Company.find(current_user.authorizations.order(id: :desc).limit(20).pluck(:company_id)) 
      @supervisor_companies = Company.find(Delegation.with_email(current_user.email).as_supervisor.accepted.order(id: :desc).limit(20).pluck(:company_id))
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
    @company = Company.new(company_params)
    @company.creator = current_user

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'La empresa fué creada exitosamente' }
        format.json { render :index, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/:id or /companies/:id.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :index, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def delegate
    @is_owner = @company.creator_id == current_user.id ? true : false
  end

  def delegate_user
    delegate = Delegation.new
    delegate.company = @company
    delegate.creator = current_user
    delegate.role =  (@company.creator_id == current_user.id)? Role::ROL_APODERADO : Role::ROL_SUPERVISOR
    delegate.email = company_params.dig(:delegation, :email)
    respond_to do |format|
      if delegate.save
        format.html { redirect_to @company, notice: 'La empresa fué delegada exitosamente' }
        format.json { render :index, status: :created, location: @company }
      else
        format.html { redirect_to :delegate_company }
      end
    end
  end

  # DELETE /companies/:id or /companies/:id.json
  # def destroy
  #   @company.destroy
  #   respond_to do |format|
  #     format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

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