class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.10.tar.xz"
  sha256 "0b9f0a9621cbc216782cdf7f767374320c0acfc394243f989aabd9af4a7cfb41"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "01ec37f862cee37311629ad3b78d3633e8cbe5b69c2b11c8b87e6b8bb5bc877e" => :catalina
    sha256 "c26b42ebb6da35e96f197b42c164fc0a707f522b60f5c2c374b3b0c598c87965" => :mojave
    sha256 "e1f4857f5f77a57288158cbb74dfe1024318aa75253086a4b2d37519b1efbad4" => :high_sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
