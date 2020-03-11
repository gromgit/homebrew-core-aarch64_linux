class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.1.tar.xz"
  sha256 "eb57394c0a908ff63623d179e09fa1e9d6b38d31c7eb597d3021489f297e71d4"

  bottle do
    sha256 "956765b4178e65cf4565d9f9fee4606cb39328185ec0e2d3d1fd641bebb287a4" => :catalina
    sha256 "bd1b9bc311b9889bcca79ff3e6516e645a54d04e9bfe4bed8e3c7e16f6251933" => :mojave
    sha256 "51e991285329196ea8ecaf6f6e12cf6d6490f7a1de46e5ef571f45f22814f865" => :high_sierra
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
