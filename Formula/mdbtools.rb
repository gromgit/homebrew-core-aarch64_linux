class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/brianb/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v0.9.0/mdbtools-0.9.0.tar.gz"
  sha256 "8ce95f62c32f9c5c1c1dcb1c853a35b735e2158bf5ceb0c041e2e9557ff536af"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "951f06fb69f1a28942e6eca0a2d850f9d916f011489fdf5f020bc3cf651b7c83" => :big_sur
    sha256 "438ff8e5d6621ec779e8a0f61ad4ee28eb90475145ecaecc55decfb79d140286" => :arm64_big_sur
    sha256 "bf7540031032765b8e7fdc8e178a026f0e8510f08351e1f79fe1a17108807f1a" => :catalina
    sha256 "20d12c72a3b59fe33f0989ebda42a2baf211e323e347d90e6f4cf33a64c2213d" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-sql",
                          "--enable-man"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
