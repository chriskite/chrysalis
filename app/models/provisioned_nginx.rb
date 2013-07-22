class ProvisionedNginx < ActiveRecord::Base
  belongs_to :pull_request
  attr_accessible :sites_available_file, :sites_enabled_file

  def self.create(pull_request)
    config_dir = Rails.configuration.nginx_config_dir
    sites_available_file = File.join(config_dir, 'sites_available', pull_request.number) 
    sites_enabled_file = File.join(config_dir, 'sites_enabled', pull_request.number) 
    config_template = pull_request.repo.nginx_template

    # write the repo's nginx config template to the sites available file
    # performing substitution on the {{number}} and {{build_dir}} variables
    File.open(sites_available_file, 'w') do |file|
      {
        "{{number}}": pull_request.number,
        "{{build_dir}}": pull_request.build_path
      }.each do |token, val|
        config_template.gsub!(token, val)
      end
      file.write(config_template)
    end
    FileUtils.ln_s(sites_available_file, sites_enabled_file)

    self.new(
      sites_available_file: sites_available_file,
      sites_enabled_file: sites_enabled_file
    )
  end

  def self.restart_nginx

  end

end
