class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.99/libgit2-glib-0.99.0.1.tar.xz"
  sha256 "e05a75c444d9c8d5991afc4a5a64cd97d731ce21aeb7c1c651ade1a3b465b9de"
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "5c25dc11f5ece68ba259cc2a7833a06448e9a760af2da879878da4331b7445d5" => :catalina
    sha256 "ae7bdeaf32d9b2ad8750f334322c0259787d4e5a67bf1f408613320dac9e882f" => :mojave
    sha256 "d814e394b79a6a34e8d36d9445d5ba3d28be87bbef079f09b2a5e45c798e5f33" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpython=false",
                      "-Dvapi=true",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
      libexec.install Dir["examples/*"]
    end
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
