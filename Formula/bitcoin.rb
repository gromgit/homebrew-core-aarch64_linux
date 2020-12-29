class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.20.1/bitcoin-0.20.1.tar.gz"
  sha256 "4bbd62fd6acfa5e9864ebf37a24a04bc2dcfe3e3222f056056288d854c53b978"
  license "MIT"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1e2fe63b8580df5b16c631289709906fe29622586fa1902ef3de48fc2303c40e" => :big_sur
    sha256 "161323955232dfbd43f8a321cf9f486eb1bed5f70a29a6dc75160c23310fbe12" => :catalina
    sha256 "95bc5ca10981145ccc2de631e6d684aa9ec920a7dfca6204f1dcd63ddbb97f16" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "zeromq"

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  plist_options manual: "bitcoind"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/bitcoind</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
