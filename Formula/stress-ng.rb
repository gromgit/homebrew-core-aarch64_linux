class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.07.tar.gz"
  sha256 "f7c0a0d0f49c39ff9b1a45919741e60e770c7873851028f46b4bbefd1e8a4e74"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b81c8396076b2233f3d4309edfcea3851f559baa57bd0a380a250b59871b1477"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d48466537fd65580d8794b66a3f968cf9db8de802f18403241270cc963039cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "6f58889c5359790e4451034d9e80e6d9ec4c67532de1afdae2fb6c5751d16120"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebb12f258d0eff88636563e23233775bf29df94d2e2e1a289d4f96e1c0a5d046"
    sha256 cellar: :any_skip_relocation, catalina:       "a611e635cd91020b03c2690113fbb61b53327f7dd45e3239ef9afc1710dbdbde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb322a5da3b392d6f191b4b69e1dabad59e8a21386f1dfbb7fb40152efb993b"
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
