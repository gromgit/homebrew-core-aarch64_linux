class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "d85617fe10eb5228ee1fdddf92e1df3ae554b0b7e6f93c0ef03f77e0daec86f2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96e9647fa1c9772e6208afcc775b3a6f6ef99816cfe52b50ab15a16fbce6446c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96e9647fa1c9772e6208afcc775b3a6f6ef99816cfe52b50ab15a16fbce6446c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96e9647fa1c9772e6208afcc775b3a6f6ef99816cfe52b50ab15a16fbce6446c"
    sha256 cellar: :any_skip_relocation, ventura:        "176aab0919d0f81555b62bd56af3ffbd854d03ac2f7ccaf71a51b367e42e4202"
    sha256 cellar: :any_skip_relocation, monterey:       "176aab0919d0f81555b62bd56af3ffbd854d03ac2f7ccaf71a51b367e42e4202"
    sha256 cellar: :any_skip_relocation, big_sur:        "176aab0919d0f81555b62bd56af3ffbd854d03ac2f7ccaf71a51b367e42e4202"
    sha256 cellar: :any_skip_relocation, catalina:       "176aab0919d0f81555b62bd56af3ffbd854d03ac2f7ccaf71a51b367e42e4202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86a28b1299d9994988b575160773d0536e4b3611478568b18b4abbdbea860fcb"
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
