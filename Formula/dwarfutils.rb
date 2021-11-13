class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.3.0.tar.xz"
  sha256 "dbf4ab40bfe83787e4648ce14a734ba8b2fd4be57e781e6f5a0314d3ed19c9fe"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "494748bad08cf0d8fd24336413e005759d442e8597f2e556811bf72d82005323"
    sha256 arm64_big_sur:  "cb3c0457af92ba29ff9aa37d4ba2e7001c1c7a31ff56c1f662b51df7f9f3d465"
    sha256 monterey:       "907139689d169ebef7fdf2c87727c50b09ed7c9da591983212f9cfeb143bd183"
    sha256 big_sur:        "a8f12813cf566f8d2cb4849b69df9a20906ec30593c8ec79a025144a1a3e1070"
    sha256 catalina:       "1cc91e1d1eebd83003674a7d1f8aa57190a0757199cc26142e4da6209bf2659a"
    sha256 mojave:         "1b1c94a8d236464a7b68aa1de5d9866f66a3e76053788b2956827dd162ab0195"
    sha256 x86_64_linux:   "ff05d983981158dc7e9d5c37eb78bfe47e96c4ec4e52e5297cb0fb1d23405dd8"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--enable-shared"
    system "make", "install"
  end

  test do
    system bin/"dwarfdump", "-V"

    (testpath/"test.c").write <<~EOS
      #include <dwarf.h>
      #include <libdwarf.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        const char *out = NULL;
        int res = dwarf_get_children_name(0, &out);

        if (res != DW_DLV_OK) {
          printf("Getting name failed\\n");
          return 1;
        }

        if (strcmp(out, "DW_children_no") != 0) {
          printf("Name did not match: %s\\n", out);
          return 1;
        }

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libdwarf-0", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system "./test"
  end
end
