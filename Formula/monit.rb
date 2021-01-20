class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.27.2.tar.gz"
  sha256 "d8809c78d5dc1ed7a7ba32a5a55c5114855132cc4da4805f8d3aaf8cf46eaa4c"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b834be239da8fa63652270aed0bee59462f277dbd2e9e4fe2ad27fb2a5e57c67" => :big_sur
    sha256 "950b41279de1a6775158fd153a5731b192b321f721a44518be5f3d660b5d6d1b" => :arm64_big_sur
    sha256 "c9d58b320d444eb9b67b253313ff22871ded4c5252010bd93ea91ca142b252d0" => :catalina
    sha256 "0a2cf25ac48a3defd8898d5ae31958e96ec8be74f0b1f9c1ca162c08b7bccbc0" => :mojave
    sha256 "7150c9211a7b95d5728a471cd3c252b8171d9039b3fb2d2b9808e9f9514923d4" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  plist_options manual: "monit -I -c #{HOMEBREW_PREFIX}/etc/monitrc"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>              <string>#{plist_name}</string>
          <key>ProcessType</key>        <string>Adaptive</string>
          <key>Disabled</key>           <false/>
          <key>RunAtLoad</key>          <true/>
          <key>LaunchOnlyOnce</key>     <false/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/monit</string>
            <string>-I</string>
            <string>-c</string>
            <string>#{etc}/monitrc</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
