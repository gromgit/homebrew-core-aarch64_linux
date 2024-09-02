class Libserialport < Formula
  desc "Cross-platform serial port C library"
  homepage "https://sigrok.org/wiki/Libserialport"
  url "https://sigrok.org/download/source/libserialport/libserialport-0.1.1.tar.gz"
  sha256 "4a2af9d9c3ff488e92fb75b4ba38b35bcf9b8a66df04773eba2a7bbf1fa7529d"
  license "LGPL-3.0"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?libserialport[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libserialport"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0763376bfbf22b56e1b899eb3071779afacd8b19fc4ace104c23a05929436d72"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libserialport.h>
      int main() {
       struct sp_port *list_ptr = NULL;
       sp_get_port_by_name("some port", &list_ptr);
       return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lserialport",
                   "-o", "test"
    system "./test"
  end
end
