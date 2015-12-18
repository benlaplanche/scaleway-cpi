require 'cloud'

class ScalewayCPI < Bosh::Cloud
  require_relative 'scaleway_cpi/client'

  attr_reader :scaleway_options, :options

  def initialize(options)
    @options = options
    @scaleway_options = options.fetch('scaleway')
  end

  def has_vm?(vm_id)
    response = client.get("/servers/#{vm_id}")
    response.status == 200
  end

  private

  def client
    @client ||= ScalewayCPI::Client.new(token: scaleway_options['token'])
  end
end

