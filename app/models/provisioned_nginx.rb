class ProvisionedNginx < ActiveRecord::Base
  belongs_to :pull_request
  attr_accessible :sites_available_file, :sites_enabled_file

  def self.create(pull_request)
    config_dir = Rails.configuration.nginx_config_dir
    sites_available_file = File.join(config_dir, 'sites_available', pull_request.number) 
    sites_enabled_file = File.join(config_dir, 'sites_enabled', pull_request.number) 
    config_template = File.join(pull_request.build_path, '.chrysalis', 'nginx.conf.erb')

    FileUtils.cp(config_file, sites_available_file)
    FileUtils.ln_s(sites_available_file, sites_enabled_file)

    self.new(
      sites_available_file: sites_available_file,
      sites_enabled_file: sites_enabled_file
    )
  end

  def self.restart_nginx

  end

end
