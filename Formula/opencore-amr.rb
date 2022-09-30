class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.6.tar.gz"
  sha256 "483eb4061088e2b34b358e47540b5d495a96cd468e361050fae615b1809dc4a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/opencore-amr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/opencore-amr"
    sha256 cellar: :any_skip_relocation, x86_64_aarch64_linux: "713fcf6740c35b5befba0d624046d7a343bdfefba0599d1ac54be55149e69e04"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <opencore-amrwb/dec_if.h>
      int main(void) {
        void *s = D_IF_init();
        D_IF_exit(s);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopencore-amrwb", "-o", "test"
    system "./test"
  end
end
