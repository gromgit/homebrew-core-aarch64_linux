class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.10.tar.gz"
  sha256 "ce1aa7c9db516b4863cb0be30626a66e6495ad65249ba1a2f1587dee6e845500"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30972942502a865a5bd7a01cb2f450f2ece8285fe5dae2598133c60ee766ba4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e896363539a3536cc5e89dfad85952be7dca25293b7737aab33687f3802a5508"
    sha256 cellar: :any_skip_relocation, monterey:       "d2496aa1c50db5b31be1174c96c0a7ba1a181dc2e6093f6193d731cfc08b96c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "659df2eb300af53adc103b02d2271fe3832d82bf3e830e4c57d7241f5b9eee44"
    sha256 cellar: :any_skip_relocation, catalina:       "7d7bf2b4fcca3b968540d7d4a83948c72083f263995aedb230ec236e394da22f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338df698f9166d34543a65df63d3f3987e19b29515e1f890cadc8d3185aa6212"
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
