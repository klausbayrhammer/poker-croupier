
class Croupier::HttpRequestLight

  def initialize(url)
    uri = URI(url)
    @host, @port, @path = uri.host, uri.port, uri.path
  end

  def post(message, time_out, &block)
    begin
      try_request(message, time_out, &block)
    rescue Exception => e
      yield true, { message: e.message, code: nil } if block_given?
    end
  end

  class << self
    def post(url, message, time_out = 0.5, &block)
      self.new(url).post(message, time_out, &block)
    end
  end

  private

  def try_request(message, time_out)
    response = build_http_connection(time_out).start do |http|
      http.request(build_request(message))
    end

    yield response.code.to_i != 200, {message: response.body, code: response.code.to_i} if block_given?
  end

  def build_request(message)
    req = Net::HTTP::Post.new(@path)
    req.set_form(message)
    req
  end

  def build_http_connection(time_out)
    http_connection = Net::HTTP.new(@host, @port)
    http_connection.open_timeout = time_out
    http_connection.read_timeout = time_out
    http_connection
  end
end