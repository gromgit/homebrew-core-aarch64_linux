class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.83.tar.gz"
  sha256 "0d4e3a95db3917511f935eec6112040570665b56c668657164493b8ea683895b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43a181acc0c47ac05539eebe0c826087723afcf6c6189bdf15449caf4d12c004"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a20a13fd434b8a32d492f8682791c84b643c5591e802308232ca57424f79f1d5"
    sha256 cellar: :any_skip_relocation, monterey:       "1561fd439d7897411c203e9431ce9ad5baa532ef43cb7af16e3177ff1dfcad37"
    sha256 cellar: :any_skip_relocation, big_sur:        "996909ea6efc6673bf7c8f2453df24c49dd15ff5aa9a916c7170c997e8ade543"
    sha256 cellar: :any_skip_relocation, catalina:       "61f27251a4c8a85b577f6719be357708bb53bcd84cc12e408bdb01900fc9c840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "002454feb24094d6d05835f7063ce0708a58439438fb582c43da7784dc2734f3"
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
