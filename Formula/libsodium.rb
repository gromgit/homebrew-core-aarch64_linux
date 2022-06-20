class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://libsodium.org/"
  url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz"
  sha256 "6f504490b342a4f8a4c4a02fc9b866cbef8622d5df4e5452b46be121e46636c1"
  license "ISC"
  revision 1

  livecheck do
    url "https://download.libsodium.org/libsodium/releases/"
    regex(/href=.*?libsodium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libsodium"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "556ad3b4417d07d949930b427e235442ed9162bde67fc9cd0b230e075c03776e"
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <sodium.h>

      int main()
      {
        assert(sodium_init() != -1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lsodium", "-o", "test"
    system "./test"
  end
end
