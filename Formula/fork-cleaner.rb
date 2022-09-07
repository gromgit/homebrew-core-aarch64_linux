class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v2.2.1.tar.gz"
  sha256 "24397ec0ad89738aee48b77e80033a2e763941e67e67b673b6ff86ab04367283"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fork-cleaner"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7301a199389b3623429e8a23b681181c89bf9ff50111237dad46c3989106430d"
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
