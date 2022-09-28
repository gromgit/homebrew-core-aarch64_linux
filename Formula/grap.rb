class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "https://www.lunabase.org/~faber/Vault/software/grap/"
  url "https://www.lunabase.org/~faber/Vault/software/grap/grap-1.46.tar.gz"
  sha256 "7a8ecefdecfee96699913f2a412da68703911fa640bac3b964a413131f848bb4"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?grap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/grap"
    sha256 aarch64_linux: "913b2478cd9aa97607ea81ddf027014a783114ca85dfaf89fbd0c4b644f3bf2b"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<~EOS
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
