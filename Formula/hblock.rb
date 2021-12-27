class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.3.1.tar.gz"
  sha256 "649ef980871d4be467a43edfa99c636b95b5af38ee976985082a65c4989eac01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55b6e30c4a6f24996fc8545204ba6e6b12239f01c10a2b55c36e0c126300847"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d55b6e30c4a6f24996fc8545204ba6e6b12239f01c10a2b55c36e0c126300847"
    sha256 cellar: :any_skip_relocation, monterey:       "d55b6e30c4a6f24996fc8545204ba6e6b12239f01c10a2b55c36e0c126300847"
    sha256 cellar: :any_skip_relocation, big_sur:        "d55b6e30c4a6f24996fc8545204ba6e6b12239f01c10a2b55c36e0c126300847"
    sha256 cellar: :any_skip_relocation, catalina:       "d55b6e30c4a6f24996fc8545204ba6e6b12239f01c10a2b55c36e0c126300847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9507040d0afc93650d3b975ca02d76528b15c3481a8f857374ac0fa24c7e665f"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
