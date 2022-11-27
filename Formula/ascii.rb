class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.18.tar.gz"
  sha256 "728422d5f4da61a37a17b4364d06708e543297de0a5f70305243236d80df072d"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/ascii[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ascii"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a6b31b72b6156f6519b9fcf26d3acd2a46a1f0cb389dd2d12732d8d82cd903f7"
  end

  head do
    url "https://gitlab.com/esr/ascii.git"
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end
