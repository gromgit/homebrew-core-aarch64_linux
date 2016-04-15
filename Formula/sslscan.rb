class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.6-rbsec.tar.gz"
  version "1.11.6"
  sha256 "18932a78ad968dc5859b8cc72c84e64a46367887eb9302eaf13069bb9da1e08d"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "7fb494cd35dd02742c5bc303fa1c08e814d79c2c1ab94a7259473fa356ae0166" => :el_capitan
    sha256 "854ff0b05b00e8a53f34c1c8e802f13c3fd296460716fc78d5d818ba56d5730d" => :yosemite
    sha256 "ba2d28eb56bb0ac8563d0763e3c01ba00866ec842a8af0af688367589a462350" => :mavericks
  end

  depends_on "openssl"

  def install
    system "make"
    mkdir_p [bin, man1]
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
