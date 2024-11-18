class CompaniesController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies or /companies.json
  def index
    debugger
    if current_user.admin?
      @companies = Company.all
      @apoderado_companies = nil
    else
      @companies = current_user.companies
      @apoderado_companies = Company.find(current_user.authorizations.order(id: :desc).limit(20).pluck(:company_id)) 
      debugger
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

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
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
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/:id or /companies/:id.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :cuit, :address, :contact_name, :contact_phone, :contact_email, :estatuto_file, :creator_id)
    end
end