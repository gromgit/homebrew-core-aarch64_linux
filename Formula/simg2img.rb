class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/1.1.4.tar.gz"
  sha256 "cbd32490c1e29d9025601b81089b5aec1707cb62020dfcecd8747af4fde6fecd"
  license "Apache-2.0"
  head "https://github.com/anestisb/android-simg2img.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/simg2img"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f1e6d55f3632504018fdca41714f2d96643bba7334a143c41e4b5037b589de24"
  end

  uses_from_macos "zlib"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=512k-zeros.img", "bs=512", "count=1024"
    assert_equal 524288, (testpath/"512k-zeros.img").size?,
                 "Could not create 512k-zeros.img with 512KiB of zeros"
    system bin/"img2simg", "512k-zeros.img", "512k-zeros.simg"
    assert_equal 44, (testpath/"512k-zeros.simg").size?,
                 "Converting 512KiB of zeros did not result in a 44 byte simg"
    system bin/"simg2img", "512k-zeros.simg", "new-512k-zeros.img"
    assert_equal 524288, (testpath/"new-512k-zeros.img").size?,
                 "Converting a 44 byte simg did not result in 512KiB"
    system "diff", "512k-zeros.img", "new-512k-zeros.img"
  end
end
