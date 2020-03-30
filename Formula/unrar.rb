class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.9.2.tar.gz"
  sha256 "73d3baf18cf0a197976af2794a848893c35e7d42cee0ff364c89d2e476ebdaa6"

  bottle do
    cellar :any
    sha256 "d419ab2c23760fd3d53c9d64bbcdcf0302a38f24cd3e7fd3f87825b4b19feeda" => :catalina
    sha256 "d537112798eac8eca1f7f2f1fd14371c0930ab0d5c4aa9fe5d7e5017be94c01d" => :mojave
    sha256 "fc090e0967acbe5d14b62f1ae5b40520e335f4402d7c99ce7034153df5313ff4" => :high_sierra
  end

  def install
    # upstream doesn't particularly care about their unix targets,
    # so we do the dirty work of renaming their shared objects to
    # dylibs for them.
    inreplace "makefile", "libunrar.so", "libunrar.dylib"

    system "make"
    # Explicitly clean up for the library build to avoid an issue with an
    # apparent implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"

    bin.install "unrar"
    lib.install "libunrar.dylib"
  end

  test do
    contentpath = "directory/file.txt"
    rarpath = testpath/"archive.rar"
    data =  "UmFyIRoHAM+QcwAADQAAAAAAAACaCHQggDIACQAAAAkAAAADtPej1LZwZE" \
            "QUMBIApIEAAGRpcmVjdG9yeVxmaWxlLnR4dEhvbWVicmV3CsQ9ewBABwA="

    rarpath.write data.unpack1("m")
    assert_equal contentpath, `#{bin}/unrar lb #{rarpath}`.strip
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
