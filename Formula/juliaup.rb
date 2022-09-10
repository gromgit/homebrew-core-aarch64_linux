class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.7.23.tar.gz"
  sha256 "7b0ca8a19a358c7d2d87c5863115c00c571c534bb92ef9a17fbd77570d4122b0"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce25e27aae94675977bf89819c93f8cba7b6d2705c4e90e2512e3da80b2e1ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9deafce74a848362de49cea25d03eef936a66508f1256cfe86e7c5a6bc7f441c"
    sha256 cellar: :any_skip_relocation, monterey:       "2372d69533ed62436c77a9d6c390b902d59bdfccd94736fa55240313d091d005"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaba1aa54675d577fc937a881d6d2267adf7a09a7d3fd6782cbc909bc9908e76"
    sha256 cellar: :any_skip_relocation, catalina:       "408ce852b63ca21055808005d7d130c5f9155a267bb424ca277a2e29c29bc8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46078ecd6884e37af49005645d14ee6d878b3bff9ce95ca1431a13d020fd43f"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
