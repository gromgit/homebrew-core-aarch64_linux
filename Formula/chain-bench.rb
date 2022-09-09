class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/v0.1.4.tar.gz"
  sha256 "b75e3e1f5eba97d4d8a29a476ea4fca4a0f354ceb232028efdb50a19ebdc5afc"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466264c745d4f9c842c1903967a13c05075ca0e0f6e3b2b57a5c64738c06d640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcef25065fc2e4b5d58a5f2a2e3c1b3b63b6c1dd65205e6f002db13871ecb683"
    sha256 cellar: :any_skip_relocation, monterey:       "6ebffa05566d36ff452e9039cb588cc27b078c027ff903d67ae1c4c934bfbcf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c5a6597863c975e0bc5980ce46388b2c6bc5e53025293a91dfab78c915b1786"
    sha256 cellar: :any_skip_relocation, catalina:       "2b25624f1a3879b415135c7aae0150209a2fc6de45c5d345f785030d2d90be74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77eb844b11cd70a260c6af93d1ba9acc743e8fee16c9f6384d612896e94c2df8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    assert_match("Fetch Starting", shell_output("#{bin}/chain-bench scan", 1))

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
