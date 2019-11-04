class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.4.10+release.autotools.tar.gz"
  version "0.4.10"
  sha256 "6a2804d5491eaa90e4b2d7fb5d68e436113e8c8fd164fc705547bcb23a8f258a"

  bottle do
    cellar :any
    sha256 "1c8fc3c1afc923164fb3e9b1c97458252c717864f68b64b2e1b1462e03e8f75f" => :catalina
    sha256 "d1b5914fd51cef7ae8bfd3b442e6517ec0182c85b5fb99141959080fd87ac4c9" => :mojave
    sha256 "6fbfc0bc336191c7101e1e5c49137bd606219550fea4c3cc161997c2c9363e6a" => :high_sierra
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  resource "mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"

    system "make"
    system "make", "install"
  end

  test do
    resource("mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
