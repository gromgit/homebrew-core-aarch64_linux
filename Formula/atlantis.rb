class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.13.0.tar.gz"
  sha256 "7e06f1e4d9410611763f2a9da3d45ecba6921be77a8f5d1ebba722047cfa081f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8c0aefa951b91e25f8f056fff30b6db346a068f00d842fc3071753063156a012" => :catalina
    sha256 "cf40282b89b9a69798283312bea51f14234b4d9e116780402d766da68c670c95" => :mojave
    sha256 "6d089fb9b809612d0145a43d7fb8d991b6177c5791714a59764024eca13fe61a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"atlantis"
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
