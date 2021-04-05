class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/awslabs/s2n"
  url "https://github.com/awslabs/s2n/archive/v1.0.2.tar.gz"
  sha256 "469eb4b243b79ec69ae8ef892a9958137edbe8c1c5eaf157e247ed53cddde4f8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7da7a2e3631d8f0afd0582c174b431b386323d0ca2b83bfe26b08e80a808535c"
    sha256 cellar: :any, big_sur:       "ea8880c629f8a77d587e5e060f5c211c2b4a0e4c5e61cd90d701f4b546818926"
    sha256 cellar: :any, catalina:      "96929f93c5ab2dbeb4c48c2e3a5f50f1a500f573fde98fc33cfdd703ce6cc65d"
    sha256 cellar: :any, mojave:        "fd8736dbdb414c24f2b40c909b41cf28671f2e9bcd0e929e0e068c388377ad64"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    system "./test"
  end
end
