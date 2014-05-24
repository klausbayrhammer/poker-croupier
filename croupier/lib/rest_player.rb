
require 'net/http'
require 'json'
require 'uri'

class Croupier::RestPlayer

  attr_reader :name

  def initialize(name, url)
    @name = name
    uri = URI(url)
    @host, @port, @path = uri.host, uri.port, uri.path
    @version = nil
  end

  def bet_request(game_state)
    send_request action: 'bet_request', game_state: game_state.to_json  do |error, result|
      if error
        raise Croupier::PlayerUnreachable.new
      end

      result.to_i
    end
  end

  def showdown(game_state)
    send_request action: 'showdown', game_state: game_state.to_json
  end

  def version
    if @version.nil?
      send_request action: 'version' do |error, result|
        if error
          return 'Unknown'
        end

        @version = result
      end
    end

    @version
  end

  def running?
    send_request action: 'check' do |error, _|
      return !error
    end
  end

  private

  def send_request(message, &block)
    begin
      try_request(message, &block)
    rescue Exception => e
      Croupier::logger.error e.message
      Croupier::logger.error "Player #{name} is unreachable"
      yield true, nil if block_given?
    end
  end

  def try_request(message)
    response = build_http_connection.start do |http|
      http.request(build_request(message))
    end

    unless response.code.to_i == 200
      Croupier::logger.error "Player #{name} responded with #{response.body} (#{response.code})"
      yield true, nil if block_given?
    else
      Croupier::logger.info "Player #{name} responded with #{response.body} (#{response.code})"
      yield false, response.body if block_given?
    end
  end

  def build_request(message)
    req = Net::HTTP::Post.new(@path)
    req.set_form(message)
    req
  end

  def build_http_connection
    http_connection = Net::HTTP.new(@host, @port)
    http_connection.open_timeout = 0.5
    http_connection.read_timeout = 0.5
    http_connection
  end
end
