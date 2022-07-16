class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.88.tar.gz"
  sha256 "e375ba15fb939a171b7b39c0d0856c817f2447c3f1664ab2b25d3d74f2622619"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4d7c7ad7bea6e34fbf523f9fe0d5bbeac33d99874f288ef405cd59117db547a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a604cf1b7410ed4c398ec005a04e74528ac0bb132e3d3f13e94d95d3942306ce"
    sha256 cellar: :any_skip_relocation, monterey:       "b82b057fe7b56dc81e7367f751296855364ecdcd96972cdbbc15d5c1e2411db7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9558b2c6aba39ac07b0fdb4066b02b1fc8aade9efd3258e87517d776443664a"
    sha256 cellar: :any_skip_relocation, catalina:       "fa76d196c2a3111c9e65ce4a35806a983d7b7d6286883a1ea8828ec4c1aeb6ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc709d235b00315168dcfede8b87e48623b876fb9668e29b2aea8d8a902a4f2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
