class Komposition < Formula
  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  revision 2
  head "https://github.com/owickstrom/komposition.git"

  bottle do
    cellar :any
    sha256 "bc09194b16cfb4ceeccf71d32eb358ca3bb1ff8d329c1a6f664e067705327416" => :catalina
    sha256 "710bd68b1c34e74229f31b866e6df54fea4a2da68eb75fa415a76d86790cf284" => :mojave
    sha256 "8fbb226d70189489ec0042f70af8e9dce6d96936be907b289e50ac869aa0ee5b" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "gobject-introspection"
  depends_on "gst-libav"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "sox"

  uses_from_macos "libffi"

  # fix a constraint issue with protolude
  # remove once new version with
  # https://github.com/owickstrom/komposition/pull/102 is included
  patch do
    url "https://github.com/owickstrom/komposition/pull/102.diff?full_index=1"
    sha256 "bdf561d07f1b8d41a4c030e121becab3b70882da8ccee53c1e91c6c0931fee0c"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    output = shell_output "#{bin}/komposition doesnotexist 2>&1"
    assert_match "[ERROR] Opening existing project failed: ProjectDirectoryDoesNotExist \"doesnotexist\"", output
  end
end
