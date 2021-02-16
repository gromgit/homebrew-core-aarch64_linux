class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "http://www.waffle-gl.org/"
  url "https://gitlab.freedesktop.org/mesa/waffle/-/raw/website/files/release/waffle-1.6.2/waffle-1.6.2.tar.xz"
  sha256 "41ff9e042497e482c7294e210ebd9962e937631829a548e5811c637337cec5a5"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git"

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :test

  def install
    args = std_cmake_args + %w[
      -Dwaffle_build_examples=1
      -Dwaffle_build_htmldocs=1
      -Dwaffle_build_manpages=1
    ]

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp_r prefix/"share/doc/waffle1/examples", testpath
    cd "examples"
    system "make", "-f", "Makefile.example"
  end
end
