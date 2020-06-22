class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.1.tar.gz"
  sha256 "b228acad81f33781d53eaf313437cc5d6f66aec5a4e56c515fc1b2d51e6e8eba"
  head "https://bitbucket.org/odedevs/ode.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4bddeed55b5f77a87a6719a804e18421ede97a40350038aef4496c1d8d95a77c" => :catalina
    sha256 "430c17a4551ea6c7d4473d5344dc7b0c3951cce4cf8ce099edcfb5c88424fd67" => :mojave
    sha256 "87666bd9ae5c66430a48c0d8fd805fc3b8aff01a5a2b82c984f63b5307cd8009" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libccd"

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-libccd",
                          "--enable-shared",
                          "--disable-static",
                          "--enable-double-precision"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/ode", "-L#{lib}", "-lode",
                   "-L#{Formula["libccd"].opt_lib}", "-lccd",
                   "-lc++", "-o", "test"
    system "./test"
  end
end
