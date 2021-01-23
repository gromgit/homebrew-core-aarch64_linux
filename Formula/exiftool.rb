class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-12.16.tar.gz"
  sha256 "c140797d72acdaf04f7ce0629867353510b56fbe99ceaac0742bbc379610756a"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "460e9669b490c7eb499fe22a79a61af24274b29f8ed30630f3066b5bafc78569" => :big_sur
    sha256 "c3f82fb1ef904fdfda38001924c9a0e4c1ad97f14cee34982cf2b36c2db80a58" => :arm64_big_sur
    sha256 "b21f5d6bdf69f77fba7803b27eaf24c8f564503a192774ed4cf0c6bf259052b0" => :catalina
    sha256 "fca252c42eec5f3a026668e9e96997c57d4ce5cc4a8bfd3a844f8016fe7bc41e" => :mojave
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$1/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
