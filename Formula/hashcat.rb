class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  # MacOS curl complains about https://hashcat.net SSL cert
  # See https://github.com/Homebrew/homebrew-core/pull/56503#issuecomment-660728358
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.0.0.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.0.0.tar.gz"
  sha256 "e8e70f2a5a608a4e224ccf847ad2b8e4d68286900296afe00eb514d8c9ec1285"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "38c468de882c83d37b151f8b7c3dd84c482b6470d72feebaed8e25543bfac032" => :catalina
    sha256 "570a58e4f14c4da88b79624e62b27494e827245fe6ac052ca6a6277a8a87c0f1" => :mojave
    sha256 "d0c23b1e6d0de61088aeb3655d069683bfe2bc586f0d38090ac477d05bff6980" => :high_sierra
  end

  depends_on "gnu-sed" => :build

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0"
  end
end
