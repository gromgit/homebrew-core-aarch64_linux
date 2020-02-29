class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.10.tar.gz"
  sha256 "936a4c5b98601b52325463a397ddf11ab4106c6a7b04f8dc7cdd377efbb597de"
  head "https://github.com/pjsip/pjproject.git"

  bottle do
    cellar :any
    sha256 "784718544f0553b52ffa60aa895d405a95401112164c72962242f4b801b168c4" => :catalina
    sha256 "ea18f1105154234f2c89b17d5973fd96c4821910a3e902a70d79ba219b655a4b" => :mojave
    sha256 "05291521fbceb75e3abf7a0c185cce9c491a00afde019a52ccbbc4b91a38710c" => :high_sierra
  end

  depends_on :macos => :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.popen_read("uname -m").chomp
    rel = Utils.popen_read("uname -r").chomp
    bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{rel}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
