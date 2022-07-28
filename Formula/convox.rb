class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.5.4.tar.gz"
  sha256 "43f1647159875d1b1925e6a89649b6b98ef0b37cd979830a3f88281e0acc98a5"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4acb805af254c3b0dab065a7aa13fd38fd6914197ef0a984d6ddfd840a9e5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "341425b2ff997b95570b119ec9a8df47ef723fa9c2008972b2a66f6d00240060"
    sha256 cellar: :any_skip_relocation, monterey:       "abe9548ad5e35c997cdde591f96467375a2df039f35b55a232affd84797934d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "257b443961e3ea89203a3e1220e6482bbc01570c8446e934a859f8efc4052eff"
    sha256 cellar: :any_skip_relocation, catalina:       "e38308df39b2b98babaae81e00519b1bbb655a2c2e1119857e6ad0a97624b76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5406082f79ccacd149bc4a84b8711694a7958984c40cd4663ed39517fae47361"
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
