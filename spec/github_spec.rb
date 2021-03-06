require File.expand_path('../spec_helper', __FILE__)

module Pod
  describe GitHub do

    def stub_github_request(url, response_body)
      require 'rest'
      response = mock(:body => response_body)
      REST.expects(:get).with(url).returns(response)
    end

    describe "In general" do
      it "returns the information of a user" do
        stub_github_request('https://api.github.com/users/CocoaPods', '{"login":"CocoaPods"}')
        user = GitHub.user("CocoaPods")
        user['login'].should == 'CocoaPods'
      end

      it "returns the information of a repo" do
        stub_github_request('https://api.github.com/repos/CocoaPods/CocoaPods', '{"name":"CocoaPods"}')
        repo = GitHub.repo("https://github.com/CocoaPods/CocoaPods")
        repo['name'].should == 'CocoaPods'
      end

      it "returns the tags of a repo" do
        stub_github_request('https://api.github.com/repos/CocoaPods/CocoaPods/tags', '[{"name":"0.20.2"}]')
        tags = GitHub.tags("https://github.com/CocoaPods/CocoaPods")
        tags.find { |t| t["name"] == "0.20.2" }.should.not.be.nil
      end

      it "returns the branches of a repo" do
        stub_github_request('https://api.github.com/repos/CocoaPods/CocoaPods/branches', '[{"name":"master"}]')
        branches = GitHub.branches("https://github.com/CocoaPods/CocoaPods")
        branches.find { |t| t["name"] == "master" }.should.not.be.nil
      end
    end

    #-------------------------------------------------------------------------#

    describe "Private helpers" do

      describe "#normalized_repo_id" do

        it "returns a repo id as it is" do
          id = GitHub.send(:normalized_repo_id, "CocoaPods/CocoaPods")
          id.should == "CocoaPods/CocoaPods"
        end

        it "convertns an url to a repo id" do
          id = GitHub.send(:normalized_repo_id, "https://github.com/CocoaPods/CocoaPods")
          id.should == "CocoaPods/CocoaPods"
        end

      end

      #----------------------------------------#

      describe "#repo_id_from_url" do

        it "returns the repo id from a given github URL" do
          id = GitHub.send(:repo_id_from_url, "https://github.com/CocoaPods/CocoaPods")
          id.should == "CocoaPods/CocoaPods"
        end

        it "returns the repo id from a given github https git URL" do
          id = GitHub.send(:repo_id_from_url, "https://github.com/CocoaPods/CocoaPods.git")
          id.should == "CocoaPods/CocoaPods"
        end

        it "returns nil if the given url is not a valid github URL" do
          id = GitHub.send(:repo_id_from_url, "CocoaPods/CocoaPods")
          id.should.be.nil
        end

      end

      #----------------------------------------#

    end

    #-------------------------------------------------------------------------#

  end
end
