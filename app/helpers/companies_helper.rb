module CompaniesHelper
	def current_company
    Company.find_by(id: session[:__company_ticket__])
  end

  def company_signed_in?
    current_company.present?
  end
end
