class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.59.0.1.tar.gz"
  sha256 "ab8c41f7b7ebdbd3e0949a4a4521f34f7b08e1e8626b84158b5ad895d1abf689"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bda9e14b8635e07b90d9debce4053bf32182f20e479a0ac76060e4111df7e9ed" => :catalina
    sha256 "7211600207d5fb89be8e02c4db341b34d9245d3e670e6cc3a32cefc2220189f2" => :mojave
    sha256 "a00bfcafc6c6b4387aa11b5185585a42ad43ce6041b48cc25e401696e9b68ce8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/v1.1.tar.gz"
    sha256 "c5d77d5e811e79f824816ee06dbf92a2a7e3eb0b6d9f27088bcac8c06d930fd5"
  end

  def install
    buildpath.install resource("bde-tools")

    ENV.cxx11

    system "python", "./bin/waf", "configure", "--prefix=#{prefix}"
    system "python", "./bin/waf", "build"
    system "python", "./bin/waf", "install"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl/bsl_string.h>
      #include <bsl/bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/bsl", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
