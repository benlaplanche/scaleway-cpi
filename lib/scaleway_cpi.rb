require 'cloud'
require 'securerandom'

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


  def reboot_vm(vm_id)
    response = client.post("/servers/#{vm_id}/action",'{"action":"reboot"}')
    response.status == 202
  end

  def create_vm(agent_id, stemcell_id, resource_pool, network_spec, disk_locality = nil, environment = nil)
    post_request = {
      organization: scaleway_options['organization'],
      name: SecureRandom.uuid,
      image: scaleway_options['image'],
      tags: ["ben","tiago"]
    }

    response = client.post("/servers",post_request.to_json)
    raise response.body if response.status != 201

    response = JSON.parse(response.body)
    response["server"]["id"]
  end

  private

  def client
    @client ||= ScalewayCPI::Client.new(token: scaleway_options['token'])
  end
end

