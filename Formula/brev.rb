class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.119.tar.gz"
  sha256 "ee6e2d0d2a31a6785a466c0168e97d5e0bd25be29c7fe9aefddd2f465488de84"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51de0084af1ccf0a902e7bace9926a9c5c3063a72733107471be06f537209f2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd7d1945fb45d291314758e5e915d2d5032b956a09211f053e8b8e816c33a90a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6c33f2f84287bf40368556001b288e95adf4dcb6692fc4ea5815d73668019b"
    sha256 cellar: :any_skip_relocation, big_sur:        "71bf3364333e85a445d5dc84d0874c128911e8b7004b825e69256f4f2559781d"
    sha256 cellar: :any_skip_relocation, catalina:       "57583a95078dd2e7eca89d337386b2eb5e8202a52c2f6f6ac7e16074e824b764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499e5ef634f47bd54f2b0691cb0be8c15096aedb54b96c1ece0df16b4f8b2ef3"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
