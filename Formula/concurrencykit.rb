class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http://concurrencykit.org/"
  url "https://github.com/concurrencykit/ck/archive/0.7.0.tar.gz"
  sha256 "e730cb448fb0ecf9d19bf4c7efe9efc3c04dd9127311d87d8f91484742b0da24"
  license "BSD-2-Clause"
  head "https://github.com/concurrencykit/ck.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/concurrencykit"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "48c3514f3218ae26c3d1b704b4856ac32026779254a1840b40608e328e9d8e0f"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ck_spinlock.h>
      int main()
      {
        ck_spinlock_t spinlock;
        ck_spinlock_init(&spinlock);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lck",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
