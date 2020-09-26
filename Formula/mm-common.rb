class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.2.tar.xz"
  sha256 "a2a99f3fa943cf662f189163ed39a2cfc19a428d906dd4f92b387d3659d1641d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d7a3510229c192e7aad13d7099a922ad2626eb9edccefc5428cb62dc6eb3b31e" => :catalina
    sha256 "bba33c2217224dc5a3ed1c091201db2c3cf5ce1a497ec690e39eb63fedb63116" => :mojave
    sha256 "bba33c2217224dc5a3ed1c091201db2c3cf5ce1a497ec690e39eb63fedb63116" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    mkdir testpath/"test"
    touch testpath/"test/a"

    system bin/"mm-common-prepare", "-c", testpath/"test/a"
    assert_predicate testpath/"test/compile-binding.am", :exist?
    assert_predicate testpath/"test/dist-changelog.am", :exist?
    assert_predicate testpath/"test/doc-reference.am", :exist?
    assert_predicate testpath/"test/generate-binding.am", :exist?
  end
end
