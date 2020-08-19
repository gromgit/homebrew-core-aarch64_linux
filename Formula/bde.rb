class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.60.0.1.tar.gz"
  sha256 "07dd91acf038014ef9985ed3466346119b058445f71aa34a2d618c6c534df07a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4f0d3ff45ae75ac38274874b58ed3a5fa0a8f8d7b98224a0a8ea809da46e264" => :catalina
    sha256 "d03dbc9f00ef94ae858e28c69c8e65f7cd5be51ff30a623b5d87a024a5f6251a" => :mojave
    sha256 "c75d1a4fbf94f056f67a7d6fec064affba6035cafbde38689d1bed09acbcdea2" => :high_sierra
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
