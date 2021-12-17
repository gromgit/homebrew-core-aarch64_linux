class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.2.2.tar.gz"
  sha256 "6582301047db51bd0ec283a85ae6d3f0ddc7970620077444174a1871a12a87c6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3805dc534c0d410e71eb2fb3c1d7d86ce25e534fceb7f78afd8f36a3201a250e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f746880c342542cdc2667178c71078d45e4c08fa13435b9b3b3fc176f6ed3e8"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b04b5523b66fabe5f3e443ce01edd9468183dc27567f75e75866fbcceff4a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "53bc148f0e56c32b9591545d8642e2759f058ddd25a806f9491034b75477c4ac"
    sha256 cellar: :any_skip_relocation, catalina:       "c0dad53575c23369239e531fb5f15e7086593ffc2f3e02981c25104ea911ce78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad1bb7ea63ab091a9ecf816272522ece21ed6ce96369dca383ad7589c4ccf7f5"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
