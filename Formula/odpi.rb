class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.4.1.tar.gz"
  sha256 "c5fc27ef90d12417cb3c2bab32ed539bb4c389fde24ceb6d1df06a0985543c1a"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/odpi"
    sha256 cellar: :any_skip_relocation, x86_64_aarch64_linux: "e5b2cf74c97d5802049bccf6ba3e596c9a7f4da1d2a5e824933683de54082887"
  end

  def install
    system "make"

    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
