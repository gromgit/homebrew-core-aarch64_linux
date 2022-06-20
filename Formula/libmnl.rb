class Libmnl < Formula
  desc "Minimalistic user-space library oriented to Netlink developers"
  homepage "https://www.netfilter.org/projects/libmnl"
  url "https://www.netfilter.org/projects/libmnl/files/libmnl-1.0.5.tar.bz2"
  sha256 "274b9b919ef3152bfb3da3a13c950dd60d6e2bcd54230ffeca298d03b40d0525"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libmnl/downloads.html"
    regex(/href=.*?libmnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libmnl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c945f1d11071e1b7804851b59ff55a90b2569c95c3a48804788a7c821da012da"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <time.h>

      #include <libmnl/libmnl.h>
      #include <linux/netlink.h>

      int main(int argc, char *argv[])
      {
        struct mnl_socket *nl;
        char buf[MNL_SOCKET_BUFFER_SIZE];
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmnl", "-o", "test"
  end
end
