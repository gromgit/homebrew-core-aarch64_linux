class FseventWatch < Formula
  desc "macOS FSEvents client"
  homepage "https://github.com/proger/fsevent_watch"
  url "https://github.com/proger/fsevent_watch/archive/v0.2.tar.gz"
  sha256 "1cfd66d551bb5a7ef80b53bcc7952b766cf81ce2059aacdf7380a9870aa0af6c"
  license "MIT"
  head "https://github.com/proger/fsevent_watch.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=-DCLI_VERSION=\\\"#{version}\\\""
  end

  test do
    system "#{bin}/fsevent_watch", "--version"
  end
end
