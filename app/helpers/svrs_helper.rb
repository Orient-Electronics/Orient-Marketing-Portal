module ReportsHelper

  def json_data(data)
    ActiveSupport::JSON.decode(data)
  end

end
