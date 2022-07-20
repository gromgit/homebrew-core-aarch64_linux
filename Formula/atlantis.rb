class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.7.tar.gz"
  sha256 "1677fc9b7b3346e7816da86fc01e9f647141868652c102ec9655a56a7caff69e"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "206c1476cf733313141a0f8e961dd70eb89b1e2ec2ab192a7d975a8ab1febd19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dc8b71bfe84e87f4285b8401fe7dbf1a7149df8c107f8bc72798d306c483160"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef4024e7fc115ecd5f7358d493cb37e5324fe29a2db58befe85b04521214ce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f8f31fda42a3bd594724fa9bfcd31f5159c6d0b6ea655e9f71287584351c27"
    sha256 cellar: :any_skip_relocation, catalina:       "70a80e9aeca19be1e6e1b069b729752b79e1fad707b704a12c70e2904c69af6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdffd5c95f089564878b0d44caf3179402b13674f322a8c31a0f34b6b7580d66"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
