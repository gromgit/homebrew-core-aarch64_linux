class Progress < Formula
  desc "Coreutils progress viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.16.tar.gz"
  sha256 "59944ee35f8ae6d62ed4f9b643eee2ae6d03825da288d9779dc43de41164c834"
  license "GPL-3.0"
  head "https://github.com/Xfennec/progress.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/progress"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "babfda98c05c19f6d25d52931cae44f525545bf482f6bc75ed1244f4e3e38c96"
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
