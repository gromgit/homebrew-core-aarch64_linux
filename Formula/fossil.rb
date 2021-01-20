class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.14.tar.gz"
  sha256 "b8d0c920196dd8ae29152fa7448e513a1fa7c588871b785e3fbfc07b42a05fb9"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/index.html/uv/download.js"
    regex(/"title": *?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    cellar :any
    sha256 "b457dfa340e0880a1f782372556d892b3bd76b71515abb8535745270781f1cb7" => :big_sur
    sha256 "0a9877c27188015e87c4c2585256fe95741917969936cbe0b85182badcf229fa" => :arm64_big_sur
    sha256 "660528f6b90d429f05434f5c8d1c7ac8a6c5df0bf6ea94f3bcdb6095365df7da" => :catalina
    sha256 "d756776b71f3fb2d0ddf99defd245142d2bac68450444133fd969433d2808e12" => :mojave
    sha256 "9e8925d6033240a79da02222aa272de41daea0e45cf67b54117f1f0cb42ab6be" => :high_sierra
  end

  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
