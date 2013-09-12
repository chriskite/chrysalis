module PullRequestsHelper
  include Ansible

  def ansi2html(str)
    ansi_escaped(str.gsub("\n", "<br />"))
  end
end
