class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.6.tar.gz"
  sha256 "2bb439db67e537d0671166ad4d522290859e8e56c2f495c76faa97bc91b28612"

  livecheck do
    url :homepage
    regex(/href=.*?CCfits[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ccfits"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "717b0fb67607840f9d7217c8fcfbda67af2d3f94cf93cfa66c2195f0d548197c"
  end

  depends_on "cfitsio"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    # Remove references to brew's shims
    args << "pfk_cxx_lib_path=/usr/bin/g++" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <CCfits/CCfits>
      #include <iostream>
      int main() {
        CCfits::FITS::setVerboseMode(true);
        std::cout << "the answer is " << CCfits::VTbyte << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lCCfits"
    assert_match "the answer is -11", shell_output("./test")
  end
end
