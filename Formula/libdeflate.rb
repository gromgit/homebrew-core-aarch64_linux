class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.10.tar.gz"
  sha256 "5c1f75c285cd87202226f4de49985dcb75732f527eefba2b3ddd70a8865f2533"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libdeflate"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fb14caf3d2f0cb2f69ee0727550f278009d185e7f1cc51753adc68b4903c87e8"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
