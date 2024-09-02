class Bas55 < Formula
  desc "Minimal BASIC programming language interpreter as defined by ECMA-55"
  homepage "https://jorgicor.niobe.org/bas55/"
  url "https://jorgicor.niobe.org/bas55/bas55-1.19.tar.gz"
  sha256 "566097e216dab029d51afefdacf7806f249d57d117ca3e875e27c6cf61098ee0"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?bas55[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bas55"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0fa28a299a7cbe2befb8afc3338f712aa65168c8187595eabe6ee751e0144fce"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.bas").write <<~EOS
      10 PRINT "HELLO, WORLD"
      20 END
    EOS

    assert_equal "HELLO, WORLD\n", shell_output("#{bin}/bas55 hello.bas")
  end
end
