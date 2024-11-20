class ApiResponse
  def self.response(data, messages, status)
    response = {
      data: data,
      messages: messages.is_a?(Array) ? messages : [messages]
    }
    return render json: response, status: status
end