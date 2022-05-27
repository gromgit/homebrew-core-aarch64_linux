class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.4.5.tar.gz"
  sha256 "deddf3f2f880b936810e08518709d7059ea606fc9d3bd6384d28cf9f042694bf"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60fc806b56ea765b177732030cd7d369c41493affa334f2b8b51f59a66f925da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1930aeeecc62798bad43bd98366acf8bf9fef24b026303c27503afce748fd4d8"
    sha256 cellar: :any_skip_relocation, monterey:       "a5bb25d1fcdeea7f606dac8520303bebe0fb8cd370ee1d103919055ce1ed0f84"
    sha256 cellar: :any_skip_relocation, big_sur:        "b53b19606614ec0c58f4ffde1bd33cc7c8f4f2541e061811beb44b4038cefbd0"
    sha256 cellar: :any_skip_relocation, catalina:       "2883dc553a36f26ff1bc58e5e0fead4b39f3695fbbe5bd972b7c80d6c184ac78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d430a5e9bd794e6c7554d427a66623dca69dd35157baf0095ee66aa6cadf97e"
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
