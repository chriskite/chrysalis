require 'spec_helper'

describe "repos/new" do
  before(:each) do
    assign(:repo, stub_model(Repo,
      :name => "MyString",
      :owner => "MyString",
      :token => "MyString"
    ).as_new_record)
  end

  it "renders new repo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", repos_path, "post" do
      assert_select "input#repo_name[name=?]", "repo[name]"
      assert_select "input#repo_owner[name=?]", "repo[owner]"
      assert_select "input#repo_token[name=?]", "repo[token]"
    end
  end
end
