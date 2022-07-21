class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "6345b1afd6c32adb296956c10553b93f23aab0571bd149345d415dbaaa53ea28"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6db386b15aa8e3d5970ae4743744a69c4025204654d8ce3960fb2bb2b942f421"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db386b15aa8e3d5970ae4743744a69c4025204654d8ce3960fb2bb2b942f421"
    sha256 cellar: :any_skip_relocation, monterey:       "5e95898dd62912c6c796b6197b5784ff8144e92618dacd3c8de8c680f926e77f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e95898dd62912c6c796b6197b5784ff8144e92618dacd3c8de8c680f926e77f"
    sha256 cellar: :any_skip_relocation, catalina:       "5e95898dd62912c6c796b6197b5784ff8144e92618dacd3c8de8c680f926e77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3f93c5a3a485f2329b45f7248bebe6bb3ff7dd58f5fefa1c6726ad1f34fbeba"
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
