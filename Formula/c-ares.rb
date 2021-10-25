class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  # Check whether patch for `node.rb` can be removed at version bump
  url "https://c-ares.org/download/c-ares-1.18.0.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.18.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.18.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.18.0.tar.gz"
  sha256 "71c19708ed52a60ec6f14a4a48527187619d136e6199683e77832c394b0b0af8"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7781f0e1ba65cf1876352302a4c609cf09a00f0cdc65560b6306e52ade04ce43"
    sha256 cellar: :any,                 arm64_big_sur:  "faf4361fe875f4b4d9fa521c3aed53ae6ad1935a859dec0b7cfd4638c6841a82"
    sha256 cellar: :any,                 monterey:       "f62e3f69f95773d86212a1855b6c00b30932f2876c2f2d800b16955728ccd939"
    sha256 cellar: :any,                 big_sur:        "999647263cf8819d6fd324ce9bf48ea5eaa94b34f7796c1fe3d772572f361459"
    sha256 cellar: :any,                 catalina:       "8cf15891ac55f5d9d7a28a5122e7c5ee6c9585c82643b029ee5c295bfd408209"
    sha256 cellar: :any,                 mojave:         "60adc74ad87d834ff201feef8a25c7e27b8ae8e3d1d09f71b08f41384cf994e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23f4ffa78d6eb7595ffd15c22067ef5ecb8370fbbdeb4cef0f7e178e6a34e3b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
