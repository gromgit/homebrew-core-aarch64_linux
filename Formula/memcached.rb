class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.5.tar.gz"
  sha256 "1f4da3706fc13c33be9df97b2c1c8d7b0891d5f0dc88aebc603cb178e68b27df"
  head "https://github.com/memcached/memcached.git"

  bottle do
    cellar :any
    sha256 "84142958ca828054ee982b489307d5a66a0c8c5e217683fc21866648badcd98a" => :catalina
    sha256 "f835f7176d16ffc9860d25a3148d5d5aafee7a102fc66f09d682f20dac5e1edb" => :mojave
    sha256 "b9d3495d7d67e870679135f0ff5ce44aa7318077d68b7da0932b307819a74e34" => :high_sierra
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

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
