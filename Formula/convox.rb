class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.4.7.tar.gz"
  sha256 "56c99f84649093adaba7f0c617dbde686c1c15a5cebfb6288d578075ca4c67ce"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8010f933f47bf96df9b60e006498bc8886d4e83cdd9ead80227d70c48ada48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee2556f38008e101cc7231405e6e18e86e1f631610a111029f02db19cc9174f6"
    sha256 cellar: :any_skip_relocation, monterey:       "10f01d6463ce97926171662414c1f58dd6a0b19aa9d77444442f92336cd6e446"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f37ffb45fd8af6d4297e57da503fbb6f82c7824dadc0c1a4e0c80269f778ba8"
    sha256 cellar: :any_skip_relocation, catalina:       "added719ba2550f8998b3cfe559cd3ac9f0164cd10f360f8a2c8cf35f3d0ecfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4705b38b9f63935bf5ed65317d43be554cac0e1f388a239d4355f85d9be0bb8"
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

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
