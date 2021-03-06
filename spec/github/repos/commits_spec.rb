require 'spec_helper'

describe Github::Repos::Commits, :type => :base do

  describe "commits" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/commits").
          to_return(:body => fixture('repos/commits.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.repos.commits }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.commits user, repo
        a_get("/repos/#{user}/#{repo}/commits").should have_been_made
      end

      it "should return array of resources" do
        commits = github.repos.commits user, repo
        commits.should be_an Array
        commits.should have(1).items
      end

      it "should be a mash type" do
        commits = github.repos.commits user, repo
        commits.first.should be_a Hashie::Mash
      end

      it "should get commit information" do
        commits = github.repos.commits user, repo
        commits.first.author.name.should == 'Scott Chacon'
      end

      it "should yield to a block" do
        github.repos.should_receive(:commits).with(user, repo).and_yield('web')
        github.repos.commits(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/commits").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.commits user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # commits

  describe "commit" do
    let(:sha) { '23432dfosfsufd' }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/commits/#{sha}").
          to_return(:body => fixture('repos/commit.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without sha key" do
        expect {
          github.repos.commit(user, repo, nil)
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.commit user, repo, sha
        a_get("/repos/#{user}/#{repo}/commits/#{sha}").should have_been_made
      end

      it "should get commit information" do
        commit = github.repos.commit user, repo, sha
        commit.commit.author.name.should == 'Monalisa Octocat'
      end

      it "should return mash" do
        commit = github.repos.commit user, repo, sha
        commit.should be_a Hashie::Mash
      end

    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/commits/#{sha}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.repos.commit user, repo, sha
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # commit

  describe "commit comments" do
    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/comments").
          to_return(:body => fixture('repos/repo_comments.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without username" do
        github.user, github.repo = nil, nil
        expect { github.repos.repo_comments }.to raise_error(ArgumentError)
      end

      it "should get the resources" do
        github.repos.repo_comments user, repo
        a_get("/repos/#{user}/#{repo}/comments").should have_been_made
      end

      it "should return array of resources" do
        repo_comments = github.repos.repo_comments user, repo
        repo_comments.should be_an Array
        repo_comments.should have(1).items
      end

      it "should be a mash type" do
        repo_comments = github.repos.repo_comments user, repo
        repo_comments.first.should be_a Hashie::Mash
      end

      it "should get commit comment information" do
        repo_comments = github.repos.repo_comments user, repo
        repo_comments.first.user.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.repos.should_receive(:repo_comments).with(user, repo).and_yield('web')
        github.repos.repo_comments(user, repo) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/comments").
          to_return(:body => "", :status => [404, "Not Found"])
      end

      it "should return 404 with a message 'Not Found'" do
        expect {
          github.repos.repo_comments user, repo
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # repo comments

  describe "commit_comments" do
    let(:sha) { '23432dfosfsufd' }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/commits/#{sha}/comments").
          to_return(:body => fixture('repos/commit_comments.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without sha key" do
        expect {
          github.repos.commit_comments(user, repo, nil)
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.commit_comments user, repo, sha
        a_get("/repos/#{user}/#{repo}/commits/#{sha}/comments").should have_been_made
      end

      it "should return array of resources" do
        commit_comments = github.repos.commit_comments user, repo, sha
        commit_comments.should be_an Array
        commit_comments.should have(1).items
      end

      it "should be a mash type" do
        commit_comments = github.repos.commit_comments user, repo, sha
        commit_comments.first.should be_a Hashie::Mash
      end

      it "should get commit comment information" do
        commit_comments = github.repos.commit_comments user, repo, sha
        commit_comments.first.user.login.should == 'octocat'
      end

      it "should yield to a block" do
        github.repos.should_receive(:commit_comments).with(user, repo, sha).and_yield('web')
        github.repos.commit_comments(user, repo, sha) { |param| 'web' }
      end
    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/commits/#{sha}/comments").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.repos.commit_comments user, repo, sha
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # commit_comments

  describe "commit_comment" do
    let(:comment_id) { 1 }

    context "resource found" do
      before do
        stub_get("/repos/#{user}/#{repo}/comments/#{comment_id}").
          to_return(:body => fixture('repos/commit_comment.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without comment id" do
        expect {
          github.repos.commit_comment user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.repos.commit_comment user, repo, comment_id
        a_get("/repos/#{user}/#{repo}/comments/#{comment_id}").should have_been_made
      end

      it "should get commit comment information" do
        commit_comment = github.repos.commit_comment user, repo, comment_id
        commit_comment.user.login.should == 'octocat'
      end

      it "should return mash" do
        commit_comment = github.repos.commit_comment user, repo, comment_id
        commit_comment.should be_a Hashie::Mash
      end

    end

    context "resource not found" do
      before do
        stub_get("/repos/#{user}/#{repo}/comments/#{comment_id}").
          to_return(:body => '', :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.repos.commit_comment user, repo, comment_id
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # commit_comment

  describe "create_comment" do
    let(:sha) { '23432dfosfsufd' }
    let(:inputs) { {'body'=> 'web', :commit_id => 1, :line => 1, :path => 'file1.txt', :position => 4 } }

    context "resouce created" do
      before do
        stub_post("/repos/#{user}/#{repo}/commits/#{sha}/comments").with(inputs).
          to_return(:body => fixture('repos/commit_comment.json'), :status => 201, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to create resource if 'body' input is missing" do
        expect {
          github.repos.create_comment user, repo, sha, inputs.except('body')
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'commit_id' input is missing" do
        expect {
          github.repos.create_comment user, repo, sha, inputs.except(:commit_id)
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'line' input is missing" do
        expect {
          github.repos.create_comment user, repo, sha, inputs.except(:line)
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'path' input is missing" do
        expect {
          github.repos.create_comment user, repo, sha, inputs.except(:path)
        }.to raise_error(ArgumentError)
      end

      it "should fail to create resource if 'position' input is missing" do
        expect {
          github.repos.create_comment user, repo, sha, inputs.except(:position)
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.repos.create_comment user, repo, sha, inputs
        a_post("/repos/#{user}/#{repo}/commits/#{sha}/comments").with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.repos.create_comment user, repo, sha, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the commit comment information" do
        comment = github.repos.create_comment user, repo, sha, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/repos/#{user}/#{repo}/commits/#{sha}/comments").with(inputs).
          to_return(:body => fixture('repos/commit_comment.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.create_comment user, repo, sha, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # create_comment

  describe "delete_comment" do
    let(:comment_id) { 1 }

    context "resource deleted successfully" do
      before do
        stub_delete("/repos/#{user}/#{repo}/comments/#{comment_id}").
          to_return(:body => '', :status => 204, :headers => { :content_type => "application/json; charset=utf-8"})
      end

      it "should fail to delete without 'user/repo' parameters" do
        github.user, github.repo = nil, nil
        expect { github.repos.delete_comment }.to raise_error(ArgumentError)
      end

      it "should fail to delete resource without 'comment_id'" do
        expect {
          github.repos.delete_comment user, repo, nil
        }.to raise_error(ArgumentError)
      end

      it "should delete the resource" do
        github.repos.delete_comment user, repo, comment_id
        a_delete("/repos/#{user}/#{repo}/comments/#{comment_id}").should have_been_made
      end
    end

    context "failed to delete resource" do
      before do
        stub_delete("/repos/#{user}/#{repo}/comments/#{comment_id}").
          to_return(:body => '', :status => 404, :headers => { :content_type => "application/json; charset=utf-8"})

      end

      it "should fail to find resource" do
        expect {
          github.repos.delete_comment user, repo, comment_id
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # delete_comment

  describe "update_comment" do
    let(:comment_id) { 1 }
    let(:inputs) { {'body'=> 'web'} }

    context "resouce created" do
      before do
        stub_patch("/repos/#{user}/#{repo}/comments/#{comment_id}").with(inputs).
          to_return(:body => fixture('repos/commit_comment.json'), :status => 200, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to create resource if 'body' input is missing" do
        expect {
          github.repos.update_comment user, repo, comment_id, inputs.except('body')
        }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.repos.update_comment user, repo, comment_id, inputs
        a_patch("/repos/#{user}/#{repo}/comments/#{comment_id}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.repos.update_comment user, repo, comment_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the commit comment information" do
        comment = github.repos.update_comment user, repo, comment_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to update resource" do
      before do
        stub_patch("/repos/#{user}/#{repo}/comments/#{comment_id}").with(inputs).
          to_return(:body => fixture('repos/commit_comment.json'), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})

      end

      it "should fail to retrieve resource" do
        expect {
          github.repos.update_comment user, repo, comment_id, inputs
        }.to raise_error(Github::ResourceNotFound)
      end
    end
  end # update_comment

end # Github::Repos::Commits
