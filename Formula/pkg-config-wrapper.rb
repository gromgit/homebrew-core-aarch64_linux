class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/v0.2.10.tar.gz"
  sha256 "460b389eeccf5e2e073ba3c77c04e19181e25e67e55891c75d6a46de811f60ce"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "642ccc08ee3a39471daa2b1e7f926cee5d173821878bc77d9e298b9c0108b89e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1caaf30307c75b18e9434b8d28b1fa877825a0332192d6b5e555bc6338cbc700"
    sha256 cellar: :any_skip_relocation, monterey:       "603f840c5a006edaac162f6abc8168683ceae3052e1ffff51a02c67dd0f36f2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2f979b30b1624461c21b86171e8bb51b2fd944ef50a457c86bc413ba8e215c4"
    sha256 cellar: :any_skip_relocation, catalina:       "aeb1e7c82bd5e1170fe21c233014efbff92de419207d802d2a919a0d6571d937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4e9b4ed125406142cc2959c7f05132dd6d103829999fc7f69e43dd093e7eb50"
  end

  depends_on "go" => :build
  depends_on "pkg-config"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output(bin/"pkg-config-wrapper 2>&1", 1)
  end
end
