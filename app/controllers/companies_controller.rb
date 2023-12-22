# frozen_string_literal: true

class CompaniesController < ApplicationController
  def index; end

  def edit
    @company = Company.find(params[:id])
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company, notice: '創建公司成功'
    else
      render :new
    end
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      redirect_to @company, notice: '更新成功'
    else
      render :edit
    end
  end

  private

  def company_params
    params.require(:company)
          .permit(:name, :gui, :email, :password, :password_confirmation, :hr_name, :hr_email, :hr_password, :hr_password_confirmation)
  end
end
