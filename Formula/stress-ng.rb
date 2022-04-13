class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.00.tar.gz"
  sha256 "d0cc53073e0c2499e15044fbd5a0df0176521575ea13fba01f67834b9e07d19d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f009d191263fea0f03e9fa39af57211d4febae3c41ffdd0f46c1e4f4638ccbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "768493a7ed49686b8141cbb81a35a8773aef5b9a8e66243a979a22c0f96ef8fb"
    sha256 cellar: :any_skip_relocation, monterey:       "76bf08d18ecf0092bb8c4b387cc913ec083250ac24bbe8c481db7e1b1dca2bbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "65cfe0bb549e787d1f835c6e4d6c44b0400b2099de4e78fe1880c25a7b2ead19"
    sha256 cellar: :any_skip_relocation, catalina:       "6c909b6679e597c396669e216429e9fe1900445c30906c6460070d4037d229b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17dadcfb36c8c2dd96dc0bad87a4af9f5639559277a689dd493a592bfd17ce09"
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
