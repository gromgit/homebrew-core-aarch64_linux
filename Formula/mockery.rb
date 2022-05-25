class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.12.3.tar.gz"
  sha256 "78991251b8b6e1ca1d70c3604040802c007737284580fb2e35612624804028f5"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b42dcebb809c7dd4e996daff769a3d56ef3cfa2606156d5f3cd60b35ddc07ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21c3e2a6c2a40f4dec0807baf81036b67c550a68cb1cb8d8809e0c34ea3cf61f"
    sha256 cellar: :any_skip_relocation, monterey:       "b396e31835353cdce1d35017eec7b70366a1ce21ab26a3cadda2aeb3417ab652"
    sha256 cellar: :any_skip_relocation, big_sur:        "a06c35a6032c71d7a266213fd93ee7d07e5bb472b7ffe80cf41818f5b0375b62"
    sha256 cellar: :any_skip_relocation, catalina:       "674d6d716c0e7fcd95d2d5d4d6521686454003d12f5d63240deb2512b788b0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aa04a95022ed4c15f0bd9b4d6b21d4526f13e57580a814968ab6842d5d07863"
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
