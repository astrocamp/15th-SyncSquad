module CompaniesHelper
	

  def company_signed_in?
    current_company.present?
  end
end
