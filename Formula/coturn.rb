class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.3/turnserver-4.5.1.3.tar.gz"
  sha256 "408bf7fde455d641bb2a23ba2df992ea0ae87b328de74e66e167ef58d8e9713a"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "http://turnserver.open-sys.org/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "5d799451b19a9b46d9d9c69349072fb8884dcef31e487eb846472fac06a83d54" => :big_sur
    sha256 "47f02cdfba1ea04f69290cf80e78c9fcf55b2396dfab237ee313327dcdd5ce0e" => :arm64_big_sur
    sha256 "87db10f79c5dce8730f955ba470e9a01513c164e9b3d5be3c027feb7208cf0d4" => :catalina
    sha256 "8cd1cb0949e458f8f8fc539d37516750660d5473fdac35eadec6468b96a52288" => :mojave
  end

  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@1.1"

  # fix compilation on macOS Big Sur
  # remove in next release
  patch do
    url "https://github.com/coturn/coturn/commit/5b07b98.patch?full_index=1"
    sha256 "186cbd35d74d440abfddf5a04c46a7ce781ceca7af989b1000feb5f98b2c270a"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--libdir=#{lib}",
                          "--docdir=#{doc}",
                          "--prefix=#{prefix}"

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  plist_options manual: "turnserver -c #{HOMEBREW_PREFIX}/etc/turnserver.conf --userdb=#{HOMEBREW_PREFIX}/opt/coturn/var/db/turndb --daemon"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/turnserver</string>
            <string>-c</string>
            <string>#{etc}/turnserver.conf</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/coturn.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/coturn.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
