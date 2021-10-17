class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "3ba724fd6b53789887665f2cf2f13525d9245b07fd558a3276b9eb6cb5904d11"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7805a618841d0763b9aa1a90a053e8d642e319825ae9a4d9925a699a04705394"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3e51027ec891d2905cadb657838e58e40b9f26ada54fea44e3715a103afd6b9"
    sha256 cellar: :any_skip_relocation, catalina:      "e3e51027ec891d2905cadb657838e58e40b9f26ada54fea44e3715a103afd6b9"
    sha256 cellar: :any_skip_relocation, mojave:        "e3e51027ec891d2905cadb657838e58e40b9f26ada54fea44e3715a103afd6b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a9df716c8956db9a5bfbbebf1305c0808f810f3ac3ed760f9bc120738ff638"
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
