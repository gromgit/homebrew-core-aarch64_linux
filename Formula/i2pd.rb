class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.34.0.tar.gz"
  sha256 "1adb4cf629f1315e9de394630b6bf1e3ba2365fd0a3601635dfb4ba9b481cb94"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "58a3cd7c41340d8ac79e1097c15b03e20ed48a7e2d7e337e2c3369a6dcc83005" => :big_sur
    sha256 "82f8bbe872eafa3a0d02275e78312c607b20706929eee9a98efa71c31a710631" => :catalina
    sha256 "764252c7b9551304cd72e851e5eae2898e19567d38813f22731c698261d5eb12" => :mojave
    sha256 "f7862fb27d6ae0ea71398b38f9bb43db4ecf5c5ef5b4cd6c58eee3b085827037" => :high_sierra
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  def install
    system "make", "install", "DEBUG=no", "HOMEBREW=1", "USE_UPNP=yes",
                              "USE_AENSI=no", "USE_AVX=no", "PREFIX=#{prefix}"

    # preinstall to prevent overwriting changed by user configs
    confdir = etc/"i2pd"
    rm_rf prefix/"etc"
    confdir.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path doesn't exist,
    # create the directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must recreate symlinks
    # to the latest version on upgrade.
    datadir = var/"lib/i2pd"
    if datadir.exist?
      rm datadir/"certificates"
      datadir.install_symlink pkgshare/"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf",
                              etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
    end

    (var/"log/i2pd").mkpath
  end

  plist_options manual: "i2pd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/i2pd</string>
          <string>--datadir=#{var}/lib/i2pd</string>
          <string>--conf=#{etc}/i2pd/i2pd.conf</string>
          <string>--tunconf=#{etc}/i2pd/tunnels.conf</string>
          <string>--log=file</string>
          <string>--logfile=#{var}/log/i2pd/i2pd.log</string>
          <string>--pidfile=#{var}/run/i2pd.pid</string>
        </array>
      </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/i2pd", "--datadir=#{testpath}", "--daemon"
    end
    sleep 5
    Process.kill "TERM", pid
    assert_predicate testpath/"router.keys", :exist?, "Failed to start i2pd"
  end
end
