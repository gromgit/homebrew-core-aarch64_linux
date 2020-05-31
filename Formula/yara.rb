class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.0.1.tar.gz"
  sha256 "c63e2c4d73fc37e860db5d7e13d945684a0a6d1d17be7161fe1dd8f99268b03c"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "aa9dba228a07da7778a4aafea4e78c013d9009bce1aa807fd1742c7afa0c2e64" => :catalina
    sha256 "77e15e1ca70c4c6cb24d3453e4b313585a5150bb28fe1ac3dacf375c3e6b5b9e" => :mojave
    sha256 "b6931e87e5bf9be9d91243e3bb8594b0ed68fe704fb28cc6d210b5b7abc17522" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto"
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<~EOS
      rule chrout {
        meta:
          description = "Calls CBM KERNAL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
