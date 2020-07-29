class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  # MacOS curl complains about https://hashcat.net SSL cert
  # See https://github.com/Homebrew/homebrew-core/pull/56503#issuecomment-660728358
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.1.1.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.1.1.tar.gz"
  sha256 "39c140bbb3c0bdb1564bfa9b9a1cff49115a42f4c9c19e9b066b617aea309f80"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "b5b947aafb8017003c92af290221e8257d47c9bb44f597cce5187f222159dcf7" => :catalina
    sha256 "5833a5a5d66131bc76a3fa0c8b86ec664e5fe5733c3323da7c8cca022b6b5882" => :mojave
    sha256 "545e53c03a95552fcfaa905dc5f5770a6bd1f05867a95e17e5a5655ab9a4d58b" => :high_sierra
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
