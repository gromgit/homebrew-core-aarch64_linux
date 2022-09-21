class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftp.gnu.org/gnu/ocrad/ocrad-0.28.tar.lz"
  mirror "https://ftpmirror.gnu.org/ocrad/ocrad-0.28.tar.lz"
  sha256 "34ccea576dbdadaa5979e6202344c3ff68737d829ca7b66f71c8497d36bbbf2e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ocrad"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "78ce30f9fc03582bd16df557320bfeec3d9c26147d046d1fd87a21a1736dffb2"
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
      P1
      # This is an example bitmap of the letter "J"
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    assert_equal "J", `#{bin}/ocrad #{testpath}/test.pbm`.strip
  end
end
