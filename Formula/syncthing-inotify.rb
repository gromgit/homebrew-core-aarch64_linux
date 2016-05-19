require "language/go"

class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.8.tar.gz"
  sha256 "886f38fa4b62ef58d54cfa379a1de7e9c461a0ff14149497934fa654e73c946a"

  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2c0a33dceee99bf0e7a3902b2a9b9a0f43a99f94c2c3e57c6c326bd6bd0661b" => :el_capitan
    sha256 "ac5c17fd02da576b0006bff8dba8badff7c057ab78e4d11751686736441c6ce7" => :yosemite
    sha256 "0befaf1bae9111d89f9862a6a44256b311ed09aeedfdf1d616273d03ea9674d6" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
      :revision => "32cd0c5b3aef12c76ed64aaf678f6c79736be7dc"
  end

  go_resource "github.com/zillode/notify" do
    url "https://github.com/Zillode/notify.git",
      :revision => "2da5cc9881e8f16bab76b63129c7781898f97d16"
  end

  def install
    ENV["GOPATH"] = buildpath
    bin_name = "syncthing-inotify"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-ldflags", "-w -X main.Version #{version}", "-o", bin_name
    bin.install bin_name
  end

  plist_options :manual => "syncthing-inotify"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/syncthing-inotify</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/syncthing-inotify.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/syncthing-inotify.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing-inotify", "-version"
  end
end
