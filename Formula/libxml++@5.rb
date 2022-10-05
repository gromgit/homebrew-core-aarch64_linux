class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/5.0/libxml++-5.0.1.tar.xz"
  sha256 "15c38307a964fa6199f4da6683a599eb7e63cc89198545b36349b87cf9aa0098"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxml++@5"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "05acd3d28c275fa143b146c83b3e3b7ce17fe4a91e14b4817fc88737aba64ddc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.10" => :build

  uses_from_macos "libxml2"

  def install
    ENV.cxx11
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-5.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
