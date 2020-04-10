class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.7.tar.gz"
  sha256 "ceee1b2ed6c2576cb66eb7a0f2669dcf85e65c0fc68385f0781b0ca4edb87eb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "17f934c5729de5f71d95fe9f472a78186f35d455982dd109f3b5d14ce3a67987" => :catalina
    sha256 "f72c448646a2921274a3b19db0d98091fb61e87b455dda595200e6db9e3ad412" => :mojave
    sha256 "8ea21321fb2535bbe20829f3de21f5c598a78abef0cac91d3f311102d9f87861" => :high_sierra
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
