class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.7.tar.gz"
  sha256 "ceee1b2ed6c2576cb66eb7a0f2669dcf85e65c0fc68385f0781b0ca4edb87eb0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7c09396cc678b8a62fec2baac29a470d0dbbe4c1b32ab0cb4dcca494c5473b42" => :catalina
    sha256 "367a724e0c91c3e10ae23a0e8967b2e9138ac772f62d496aef9ea321ed33353d" => :mojave
    sha256 "b4f5ed998f34cd4d16537c580f8bf5ada8a95730ac0645bab208652c2a3057ce" => :high_sierra
  end

  depends_on "coq" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build

  def install
    # We pass -ignore-coq-version, otherwise every new version of coq
    # breaks the strict version check.
    system "./configure", "-prefix", prefix, "x86_64-macosx",
                          "-ignore-coq-version"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int printf(const char *fmt, ...);
      int main(int argc, char** argv) {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
