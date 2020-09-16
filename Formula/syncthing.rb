class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.9.0.tar.gz"
  sha256 "ca66e0929428db2ed9476ff8ef4d46b06c5221a5aa24db504cdb2cd1aebe5ac6"
  license "MPL-2.0"
  revision 1
  head "https://github.com/syncthing/syncthing.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "66876dd60affae9317324b0092e84201beed36181695f475542c53ce00374460" => :catalina
    sha256 "9766559fd12fa67cc245bbddeaa12886bc14f502572e4308c853c6c24a6e343c" => :mojave
    sha256 "7fcce1b51391bf2c8c88d67c1b75d197d8546f822bfcc07ac1170bba20f830b3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go", "--version", "v#{version}", "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  plist_options manual: "syncthing"

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
            <string>#{opt_bin}/syncthing</string>
            <string>-no-browser</string>
            <string>-no-restart</string>
          </array>
          <key>KeepAlive</key>
          <dict>
            <key>Crashed</key>
            <true/>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>ProcessType</key>
          <string>Background</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/syncthing.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/syncthing.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
