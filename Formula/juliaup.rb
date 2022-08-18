class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.7.21.tar.gz"
  sha256 "61fdb3c30504eaa252b1d0713206c24559542f3729e9268f0cfd583309aa818c"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b70fbada9185055f2bff8db0582f73b1fcede0a6f24993cfb9351567ec3fb3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6896d8a378ec3154b384a9bb149b85409a22ca5e0d177aa7fa874180a7858127"
    sha256 cellar: :any_skip_relocation, monterey:       "6c6283efe9e64736376c9d056859040a967fd77b840023304fa911de6186b11f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e5d38c5e367b00377c0d92bea346f31109f0481e55eacc458de4cdfaca72a57"
    sha256 cellar: :any_skip_relocation, catalina:       "39b4559f4e9b361a3a0719d6f887e6d207d0c7a6b279592d9a84303057f4bc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381a7ffd9d3e228d401175ba2f9485ae854b2704c48954ea4dd9c889b70bea10"
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
