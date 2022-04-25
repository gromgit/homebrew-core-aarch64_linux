class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.12.1.tar.gz"
  sha256 "62b2652fb245372815cdce61511dcb91d83ab6944774ef8e90bab7b30b26660c"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6e2c64d12a184eade30e09ab00a1a496654071c6eddf8892b99a7448052b6ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7b3f0eb8d8ef5e59e04ea3c71c5e91a956e84b26c7149e9e63b33c8e161dfe"
    sha256 cellar: :any_skip_relocation, monterey:       "f128753d0b60818a8ab7ff8a9d7053ec0105d0f7b24963573926cf9aafbaf532"
    sha256 cellar: :any_skip_relocation, big_sur:        "892a2523b3109a1de4f03c1531d22d81be9c63e4ace180c34e8f4f9515c2352e"
    sha256 cellar: :any_skip_relocation, catalina:       "3a2cd4c71c789ce947dc12a5a002ebe3bd63bdf63cde238318f043f6a9ca4ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b7703e8d0b3655535dca05a576571e424c374f2b6ca352f34ff50c559abe6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
