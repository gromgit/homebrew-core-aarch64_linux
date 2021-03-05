class Progress < Formula
  desc "Coreutils progress viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.16.tar.gz"
  sha256 "59944ee35f8ae6d62ed4f9b643eee2ae6d03825da288d9779dc43de41164c834"
  license "GPL-3.0"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e1af2d5097f697d1e07212105ba6c4f90232b40b203ab2b4d984d67bba68d13"
    sha256 cellar: :any_skip_relocation, big_sur:       "47197bd0c9cde64b7aab94dea80f68da856ee952f11d6999dca9b1ca84c97076"
    sha256 cellar: :any_skip_relocation, catalina:      "104d62681c513b6c3e7d997245768d7e2e3941ab43dc37fb67b33bb188e4acc4"
    sha256 cellar: :any_skip_relocation, mojave:        "62ea2e563eac2c9c9ad6f8eb3d5565024b2e303313c6d5cf509901893ee01d32"
    sha256 cellar: :any_skip_relocation, high_sierra:   "699d0712e633d357dbd853e797e94f85bee3af00f70b9e206fe6335d620b8e5c"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    pid = fork do
      system "/bin/dd", "if=/dev/urandom", "of=foo", "bs=512", "count=1048576"
    end
    sleep 1
    begin
      assert_match "dd", shell_output("#{bin}/progress")
    ensure
      Process.kill 9, pid
      Process.wait pid
      rm "foo"
    end
  end
end
