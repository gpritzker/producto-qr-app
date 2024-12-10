module MenuSelectedHelper
  def menu_user?
    return true if request.path.start_with?(admin_users_path)
    false
  end

  def menu_company?
    return true if current_page?(authenticated_root_path)
    return false if request.path.match(/audits/) 
    return true if request.path.start_with?(companies_path)
    false
  end

  def menu_qrs?
    return false if request.path.match(/audits/) 
    return true if request.path.start_with?(qrs_path)
    false
  end

  def menu_djc?
    return false if request.path.match(/audits/) 
    return true if request.path.start_with?(djcs_path)
    false
  end
end
