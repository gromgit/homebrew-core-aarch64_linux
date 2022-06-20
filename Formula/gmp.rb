class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  revision 1

  stable do
    url "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
    sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://gmplib.org/download/gmp/"
    regex(/href=.*?gmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gmp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8159fd7803ae3e7592cd6532c90503cc92df7fc9c7800f3fd3bae5d4820db693"
  end

  head do
    url "https://gmplib.org/repo/gmp/", using: :hg
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "m4" => :build

  # Prevent crash on macOS 12 betas with release gmp 6.2.1, can be removed after the next gmp release.
  patch do
    url "https://gmplib.org/repo/gmp/raw-rev/5f32dbc41afc"
    sha256 "a44ef57903b240df6fde6c9d2fe40063f785995c43b6bfc7a237c571f53613e0"
  end

  def install
    system "./.bootstrap" if build.head?

    args = std_configure_args
    args << "--enable-cxx"

    # Enable --with-pic to avoid linking issues with the static library
    args << "--with-pic"

    cpu = Hardware::CPU.arm? ? "aarch64" : Hardware.oldest_cpu

    if OS.mac?
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
    else
      args << "--build=#{cpu}-linux-gnu"
      args << "ABI=32" if Hardware::CPU.is_32_bit?
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Prevent brew from trying to install metafiles that
    # are actually symlinks to files in autotools kegs
    buildpath.children.select(&:symlink?).map(&:unlink) if build.head?
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gmp.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"

    # Test the static library to catch potential linking issues
    system ENV.cc, "test.c", "#{lib}/libgmp.a", "-o", "test"
    system "./test"
  end
end
