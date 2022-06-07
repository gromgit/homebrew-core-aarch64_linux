class Joe < Formula
  desc "Full featured terminal-based screen editor"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.6/joe-4.6.tar.gz"
  sha256 "495a0a61f26404070fe8a719d80406dc7f337623788e445b92a9f6de512ab9de"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/joe[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/joe"
    sha256 aarch64_linux: "81cbb27a15c542dc68e2e76f1a834b850189d802f51caf64e559c2069eae24e8"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
