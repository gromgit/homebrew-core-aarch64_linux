class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "17e527fc18ff25c590ff8790c32322e9c9c5e036ccf279ca2ed63be870889182"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/moar"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "73873ba955e9e7685750ac7fb6fe65adf380509f6b17c56a460a0f39d83d72e1"
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
