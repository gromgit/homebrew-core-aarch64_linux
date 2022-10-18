class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.10.1.tar.gz"
  sha256 "77403d5be313d9b85ed4e5dd9ac6fb6aab197a745f7a737c82bd33c71b88958d"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b49a96b4f28526711cd1cc59e30b382540089690db23137918cdf06ad9a04669"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c1cfbbd1fd463f86936efecffc7ccaab9b616c2a470a43538845e7870218a0c"
    sha256 cellar: :any_skip_relocation, monterey:       "b4eb20cb52196fcb4990fd2a25997715fe57e55a17ce7196bd7e4c7c8abdd9ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbab6ce252f7ec2b5bd8ee06ff0689f5ade22a72e654cc3d91a053502cf962af"
    sha256 cellar: :any_skip_relocation, catalina:       "ee71e48129602335e329a649a7ec0d53d3216a551562f038b7d570503519ec5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c33e83d5ca383f8f60e61ffe271f2f9feaacdb105e4d28222c141ec57c8f34e"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
