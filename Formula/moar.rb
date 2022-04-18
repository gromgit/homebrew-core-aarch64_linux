class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "d93375774eb83bde2a171364f8166c1cd0f8d41136286a13758d05d32aeb2fa7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aa25f9952be9e05e37ca3ca01419d95b27ad67919ff399b7d549a106e596595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aa25f9952be9e05e37ca3ca01419d95b27ad67919ff399b7d549a106e596595"
    sha256 cellar: :any_skip_relocation, monterey:       "d40ab09fa8dfd023f908215dbc42fbd171416e135a76033faa7f96a19f6f821f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d40ab09fa8dfd023f908215dbc42fbd171416e135a76033faa7f96a19f6f821f"
    sha256 cellar: :any_skip_relocation, catalina:       "d40ab09fa8dfd023f908215dbc42fbd171416e135a76033faa7f96a19f6f821f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69aac8763c9ab9035a6f5d11293c59df0d877b7e96e7280bb2745902a638da2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
