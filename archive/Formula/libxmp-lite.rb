class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.5.0/libxmp-lite-4.5.0.tar.gz"
  sha256 "19a019abd5a3ddf449cd20ca52cfe18970f6ab28abdffdd54cff563981a943bb"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxmp-lite"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f23f5552db56734a75ba4292c0d8cde13705c86956af3643c5759c63a192dbda"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <libxmp-lite/xmp.h>

      int main(int argc, char* argv[]){
        printf("libxmp-lite %s/%c%u\n", XMP_VERSION, *xmp_version, xmp_vercode);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I", include, "-L", lib, "-L#{lib}", "-lxmp-lite", "-o", "test"
    system "#{testpath}/test"
  end
end
