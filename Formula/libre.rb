class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "5ffcb354d09e416fe6ce12d7245d567c21b396894240c2e137a2a009a6472f83"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libre"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ebdae99ff9e7fee80f31000b23194c149e67c5577334f31a16de3cf2ce7a4219"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
