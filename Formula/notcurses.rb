class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "d06971005e4cf637cc90a694323c580791d1450a77b1700ae8deb453678d3243"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "2f472bc6be3e450af5870241b25ce4327682ff1461ea34704727cb9e4bdbee57"
    sha256 big_sur:       "954f4b54782ec2ae31e43a8b7ca023fd58054fbcdf15bb8fd16aee083cf4c8cf"
    sha256 catalina:      "7794c0373974d63ca1d82427ebcdd3d5bd726d4ece1c2e8f6709f670a219651f"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output("#{bin}/notcurses-info", 1)
  end
end
