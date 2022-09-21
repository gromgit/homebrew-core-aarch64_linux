class Qtfaststart < Formula
  desc "Utility for Quicktime files"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.3.tar.gz"
  sha256 "115b659022dd387f662e26fbc5bc0cc14ec18daa100003ffd34f4da0479b272e"
  license :public_domain

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/qtfaststart"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "54ba90a82a218504a0b921b471b58fee1f5c21393438919ae0f1a88223f54ed3"
  end

  # See: https://lists.libav.org/pipermail/libav-devel/2020-April/086589.html
  deprecate! date: "2020-04-16", because: :unmaintained

  resource "mov" do
    url "https://github.com/van7hu/fanca/raw/master/examples/kmplayer/samples/H264_test4_Talkingheadclipped_mov_480x320.mov"
    sha256 "5af004e182ac7214dadf34816086d0a25c7a6cac568ae3741fca527cbbd242fc"
  end

  def install
    system ENV.cc, "-o", "tools/qt-faststart", "tools/qt-faststart.c"
    bin.install "tools/qt-faststart"
  end

  test do
    input = "H264_test4_Talkingheadclipped_mov_480x320.mov"
    output = "out.mov"
    resource("mov").stage { testpath.install Dir["*"].first => input }
    system bin/"qt-faststart", input, output

    assert_predicate testpath/output, :exist?
  end
end
