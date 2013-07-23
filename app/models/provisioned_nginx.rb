class ProvisionedNginx < ActiveRecord::Base
  belongs_to :pull_request

  before_destroy :destroy_nginx

  attr_accessible :sites_available_file, :sites_enabled_file

  def self.create(pull_request)
    Rails.logger.info "Provisioning Nginx for PullRequest:#{pull_request.id} Number:#{pull_request.number}"

    config_dir = Rails.configuration.nginx_config_dir
    sites_available_file = File.join(config_dir, 'sites-available', pull_request.number.to_s) 
    sites_enabled_file = File.join(config_dir, 'sites-enabled', pull_request.number.to_s) 
    config_template = pull_request.repo.nginx_template

    begin
      # write the repo's nginx config template to the sites available file
      # performing substitution on the {{number}} and {{build_dir}} variables
      File.open(sites_available_file, 'w') do |file|
        {
          "{{number}}" => pull_request.number.to_s,
          "{{build_dir}}" => pull_request.build_path.to_s
        }.each do |token, val|
          config_template.gsub!(token, val)
        end
        file.write(config_template)
      end
      FileUtils.ln_s(sites_available_file, sites_enabled_file)

      self.reload_nginx

      return self.new(
        sites_available_file: sites_available_file,
        sites_enabled_file: sites_enabled_file
      )
    rescue
      File.unlink(sites_available_file) if File.exists?(sites_available_file)
      File.unlink(sites_enabled_file) if File.exists?(sites_enabled_file)
      raise $!
    end
  end

  def self.reload_nginx
    system(Rails.configuration.nginx_reload_command)
  end

  def destroy_nginx
    File.unlink(sites_available_file) if File.exists?(sites_available_file)
    File.unlink(sites_enabled_file) if File.exists?(sites_enabled_file)
    self.class.reload_nginx
  end

end
