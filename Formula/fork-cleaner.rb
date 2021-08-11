class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v2.2.1.tar.gz"
  sha256 "24397ec0ad89738aee48b77e80033a2e763941e67e67b673b6ff86ab04367283"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "829de991792fb888129edc45f53e1cfd3dd7c3b416d9d224dfd20fd104e3de01"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c38ca3c1fdd113fa6cab6275b0b8ac09dd58c003b65b736d07525fdfcf20128"
    sha256 cellar: :any_skip_relocation, catalina:      "755110dfb469caf2412b848dc34a2f888306fe99bdd785404314e934f71314c1"
    sha256 cellar: :any_skip_relocation, mojave:        "df5b5612adc55c88a3b3eefe80f0d02ee407bacaf07ff76c24dac6bfd382086e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4636f005612e28594325f6da8d85f35e2c48e6225a127f16bcaa1d3fa05dc3b2"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "fork-cleaner"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
