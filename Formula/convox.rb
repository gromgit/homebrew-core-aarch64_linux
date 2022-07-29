class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.5.5.tar.gz"
  sha256 "bf3dcaeff130e1da9e44ff2a9d96dbcdb14dcead38b276ac8be5b7e1803d7c40"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d031902f495acab71e0c1a036a83861f2f761e124c2875b17484e3a1a86b707"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bb990fd2534a57c5235b8db2b6a8c14260bd846b8f9cfed9fb006acfc1087ea"
    sha256 cellar: :any_skip_relocation, monterey:       "594248d7bca27aa9fee683c05f870aaa7e222f6f79e0903644ce82ea95b4d2ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f376ec00f90dc8ca378b4f0049cf532b9954ba17f3b9d599d0b2e10f876a0ba"
    sha256 cellar: :any_skip_relocation, catalina:       "15da15dc2dc0536da1f97752520bd803c5bf33706686901b85e274105faf03fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f1927ed72290451949643dd92fa65f9a07aae9fa1a40ee9f7c2c8a81f1b280e"
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
