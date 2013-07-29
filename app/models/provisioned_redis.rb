class ProvisionedRedis < ActiveRecord::Base
  belongs_to :pull_request

  before_destroy :destroy_redis

  attr_accessible :config_file, :pidfile, :port, :pull_request

  def self.create(pull_request)
    port = Rails.configuration.redis_port_start + pull_request.number
    pidfile = File.join(pull_request.build_path, 'redis.pid')

    config_template = pull_request.repo.redis_template.dup rescue ""

    {
      "{{port}}" => port.to_s,
      "{{pidfile}}" => pidfile.to_s
    }.each do |token, val|
      config_template.gsub!(token, val)
    end

    config_file = File.join(pull_request.build_path, 'redis.conf')
    File.open(config_file, 'w') { |file| file.write(config_template) }

    system("#{Rails.configuration.redis_executable} #{config_file}")

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
