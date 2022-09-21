class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9531/jbig2dec-0.19.tar.gz"
  sha256 "279476695b38f04939aa59d041be56f6bade3422003a406a85e9792c27118a37"
  license "AGPL-3.0-or-later"

  # Not every GhostPDL release contains a jbig2dec archive, so we have to check
  # the GitHub releases page instead (which we otherwise avoid). This is
  # necessary because the jbig2dec homepage hasn't been updated to link to
  # versions after 0.17.
  livecheck do
    url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases"
    regex(%r{href=.*?/jbig2dec[._-]v?(\d+(?:\.\d+)+)\.t}i)
    strategy :page_match
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jbig2dec"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ac7122d60c77b3407a5873779efb5eace356dc55a9da000c4dac63670423c984"
  end


  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  resource("test") do
    url "https://github.com/apache/tika/raw/master/tika-parsers/src/test/resources/test-documents/testJBIG2.jb2"
    sha256 "40764aed6c185f1f82123f9e09de8e4d61120e35d2b5c6ede082123749c22d91"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
      --without-libpng
    ]

    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    resource("test").stage testpath
    output = shell_output("#{bin}/jbig2dec -t pbm --hash testJBIG2.jb2")
    assert_match "aa35470724c946c7e953ddd49ff5aab9f8289aaf", output
    assert_predicate testpath/"testJBIG2.pbm", :exist?
  end
end
