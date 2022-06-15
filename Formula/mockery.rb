class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.13.1.tar.gz"
  sha256 "e52ca8bfa6b6f9bfb90d42e9e065ef01484f8039731cc320f6dfe4b11fae76b9"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae3601ea655992f354ebe12fdcc5d696fed4e0fbf27750501bcc78f7702ec108"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7acb6d31fc688a4c93b0241b75f8e91dadfd912bc4a7c6029d4d5c4de064e617"
    sha256 cellar: :any_skip_relocation, monterey:       "3a62c9944aba9f1d3f5e6c993a2a12b039455c4563f07b629fffa0eb4e02d67c"
    sha256 cellar: :any_skip_relocation, big_sur:        "706972d7a1e1bc5fb41899e4e91dac3bba7f4842ded729cad568acbf5ea07aa7"
    sha256 cellar: :any_skip_relocation, catalina:       "d6fe934b90554c3296e0b534391c38757536abb2f2e82a7aaae4e963a1ca8ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075203d21350a3bb76872d02bc206a5d816b96aa6022e0a95318a72f54e97c54"
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
