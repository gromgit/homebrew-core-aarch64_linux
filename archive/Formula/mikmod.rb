class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "https://mikmod.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.8/mikmod-3.2.8.tar.gz"
  sha256 "dbb01bc36797ce25ffcab2b3bf625537b85b42534344e1808236ca612fbaa4cc"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/mikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mikmod"
    sha256 aarch64_linux: "b892b292908223ba9e84c7becc7f1f08ff43d5dbd94c435de4c430a44fff944c"
  end

  depends_on "libmikmod"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mikmod -V")
  end
end
