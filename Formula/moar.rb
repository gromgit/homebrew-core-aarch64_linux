class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "71b3d2bcc4e7ecb8aa1ccede8d5325ee3bf582753d173b87fa804d25866e7ffc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900ea87db04cb33aae60acf4ece3f807ad22a05df51b111805f92e2aa76dabed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "900ea87db04cb33aae60acf4ece3f807ad22a05df51b111805f92e2aa76dabed"
    sha256 cellar: :any_skip_relocation, monterey:       "5d3125f959075329295f18e1c2366ad6b9f1b109e10c0ec36a1618db46f5f001"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d3125f959075329295f18e1c2366ad6b9f1b109e10c0ec36a1618db46f5f001"
    sha256 cellar: :any_skip_relocation, catalina:       "5d3125f959075329295f18e1c2366ad6b9f1b109e10c0ec36a1618db46f5f001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e1696a2f4fa6ce854837b8ff036eb09a3c0fa45d0d88898e2860083f9cd9ce"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
