class DelegateCompaniesController < ApplicationController
  before_action :set_delegate_company, only: %i[ show edit update destroy ]

  # GET /delegate_companies or /delegate_companies.json
  def index
    @delegate_companies = DelegateCompany.all
  end

  # GET /delegate_companies/1 or /delegate_companies/1.json
  def show
  end

  # GET /delegate_companies/new
  def new
    @delegate_company = DelegateCompany.new
  end

  # GET /delegate_companies/1/edit
  def edit
  end

  # POST /delegate_companies or /delegate_companies.json
  def create
    @delegate_company = DelegateCompany.new(delegate_company_params)

    respond_to do |format|
      if @delegate_company.save
        format.html { redirect_to @delegate_company, notice: "Delegate company was successfully created." }
        format.json { render :show, status: :created, location: @delegate_company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delegate_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delegate_companies/1 or /delegate_companies/1.json
  def update
    respond_to do |format|
      if @delegate_company.update(delegate_company_params)
        format.html { redirect_to @delegate_company, notice: "Delegate company was successfully updated." }
        format.json { render :show, status: :ok, location: @delegate_company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delegate_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delegate_companies/1 or /delegate_companies/1.json
  def destroy
    @delegate_company.destroy

    respond_to do |format|
      format.html { redirect_to delegate_companies_path, status: :see_other, notice: "Delegate company was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delegate_company
      @delegate_company = DelegateCompany.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def delegate_company_params
      params.require(:delegate_company).permit(:email, :accepted)
    end
end
