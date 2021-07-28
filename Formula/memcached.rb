class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.10.tar.gz"
  sha256 "ef46ac33c55d3a0f1c5ae8eb654677d84669913997db5d0c422c5eaffd694a92"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a96735d33fdb0dcd009dedb7c598d2b9869520b9210f91b39719ac005eb4dec4"
    sha256 cellar: :any, big_sur:       "ef4910bde5414b88b0c3170a1716648e4f060b0660a89516bacc7056bc44bc44"
    sha256 cellar: :any, catalina:      "3ed338f8ad4acf096ffc3ee4a0d8f5c73fc968f6879de7e6e8069b8fbe237ce2"
    sha256 cellar: :any, mojave:        "477b0464e320a87acd672db7de573041ade53279afd853ce5c51786d50741d22"
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/memcached</string>
          <string>-l</string>
          <string>localhost</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    pidfile = testpath/"memcached.pid"
    system bin/"memcached", "--listen=localhost:#{free_port}", "--daemon", "--pidfile=#{pidfile}"
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
