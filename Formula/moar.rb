class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "71b3d2bcc4e7ecb8aa1ccede8d5325ee3bf582753d173b87fa804d25866e7ffc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63fcb40d61f6d98c59e6ea5522f0d6346eba8027c401529bdae05fce003b178e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63fcb40d61f6d98c59e6ea5522f0d6346eba8027c401529bdae05fce003b178e"
    sha256 cellar: :any_skip_relocation, monterey:       "4fb75f4ed3db5e46ac43b832573c0186256b5403fe70894682d01aab09d08817"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fb75f4ed3db5e46ac43b832573c0186256b5403fe70894682d01aab09d08817"
    sha256 cellar: :any_skip_relocation, catalina:       "4fb75f4ed3db5e46ac43b832573c0186256b5403fe70894682d01aab09d08817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15001a3fe0f6e6bcf851e48b9d8836df8141fdbb92e6e3bb3141d613f0786086"
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
