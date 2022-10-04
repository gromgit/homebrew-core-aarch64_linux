class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
  license "GPL-2.0"
  head "https://github.com/bitlbee/bitlbee.git", branch: "master"

  stable do
    url "https://get.bitlbee.org/src/bitlbee-3.6.tar.gz"
    sha256 "9f15de46f29b46bf1e39fc50bdf4515e71b17f551f3955094c5da792d962107e"
  end

  livecheck do
    url "https://get.bitlbee.org/src/"
    regex(/href=.*?bitlbee[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bitlbee"
    sha256 aarch64_linux: "9a0329147cb7bc3e88a37069bcdc1919ddf454a28e27e9d6078defe2ce5a8399"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"

  def install
    args = %W[
      --prefix=#{prefix}
      --plugindir=#{HOMEBREW_PREFIX}/lib/bitlbee/
      --debug=0
      --ssl=gnutls
      --etcdir=#{etc}/bitlbee
      --pidfile=#{var}/bitlbee/run/bitlbee.pid
      --config=#{var}/bitlbee/lib/
      --ipsocket=#{var}/bitlbee/run/bitlbee.sock
    ]

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make", "install"
    # Install the dev headers too
    system "make", "install-dev"
    # This build has an extra step.
    system "make", "install-etc"
  end

  def post_install
    (var/"bitlbee/run").mkpath
    (var/"bitlbee/lib").mkpath
  end

  plist_options manual: "bitlbee -D"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>OnDemand</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/bitlbee</string>
        </array>
        <key>ServiceDescription</key>
        <string>bitlbee irc-im proxy</string>
        <key>Sockets</key>
        <dict>
          <key>Listener</key>
          <dict>
            <key>SockFamily</key>
            <string>IPv4</string>
            <key>SockProtocol</key>
            <string>TCP</string>
            <key>SockNodeName</key>
            <string>127.0.0.1</string>
            <key>SockServiceName</key>
            <string>6667</string>
            <key>SockType</key>
            <string>stream</string>
          </dict>
        </dict>
        <key>inetdCompatibility</key>
        <dict>
          <key>Wait</key>
          <false/>
        </dict>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/bitlbee -V", 1)
  end
end
