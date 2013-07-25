class ProvisionedRedis < ActiveRecord::Base
  belongs_to :pull_request

  before_destroy :destroy_redis

  attr_accessible :config_file, :pidfile, :port, :pull_request

  def self.create(pull_request)
    port = Rails.configuration.redis_port_start + pull_request.number
    config_template = pull_request.repo.redis_template.dup rescue ""

    config_template.gsub!("{{port}}", port.to_s)
    pidfile = File.join(pull_request.build_path, 'redis.pid')
    # TODO insert pidfile option to config_template

    config_file = File.join(pull_request.build_path, 'redis.conf')

    File.open(config_file, 'w') { |file| file.write(config_template) }

    # TODO exec redis-server with specified config file

    self.new(
      config_file: config_file,
      pidfile: pidfile,
      port: port,
      pull_request: pull_request
    )
  end

  def destroy_redis
    system("kill -9 `cat #{pidfile}`")
    nil
  end
end
