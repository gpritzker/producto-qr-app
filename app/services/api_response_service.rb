class ApiResponseService
  def self.error(info = [], code = :unprocessable_entity)
    return { json: info.is_a?(Array) ? {errors: info}:{error: info}, status: code }
  end

  def self.ok(data = nil, info = nil)
    unless data.nil?
      response = {data: data}
    end
    unless info.nil?
      if info.is_a?(Array) 
        response[:messages] = info
      else
        response[:message] = info
      end
    end
    return { json: response, status: :ok }
  end
end