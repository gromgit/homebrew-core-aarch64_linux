class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/v2.6.16.tar.gz"
  sha256 "90af9bc9875e03fb5a09a3233287b74dd817867cb18ec9ff52fead615755563e"
  license "MIT"
  revision 1

  bottle do
    sha256 "5a38d2feddf00dd15f9c34a7d9ce8bae81a08703cc4f52cf0af52c20d7a5ef5e" => :big_sur
    sha256 "f82d8268b6a147ba30ddc7d2c1ca18045b180d2247b1f312d8d1a475ef1257f3" => :catalina
    sha256 "f32bdb431eafeb2c981d945cdd7fc6beb2ca7e5a0e98b8c8248c1ffdc953874d" => :mojave
  end

  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
    ENV.append "LDFLAGS", "-liconv"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "MYCFLAGS=#{ENV.cflags}", "MYLDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats
    <<~EOS
      You will need to create a ~/.imapfilter/config.lua file.
      Samples can be found in:
        #{prefix}/samples
    EOS
  end

  test do
    system "#{bin}/imapfilter", "-V"
  end
end
