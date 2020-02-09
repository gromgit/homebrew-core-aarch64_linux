class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.46/vala-0.46.6.tar.xz"
  sha256 "ef31649932872f094971d46453b21c60a41661670f98afa334062425b4aec47a"

  bottle do
    sha256 "1efbe37b49fdb222e25cc46df6429fe1debbb4a2dc178c7c461013ff2ed8cb89" => :catalina
    sha256 "73fbe462704230a7c8c9144c6e36ca85d10c5c859da6a812f5fd548da9c85e95" => :mojave
    sha256 "22aa7ff3fe44822f418b8431f04dd29117d4fd8199c3fda14ab184b6a03d4d59" => :high_sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

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
