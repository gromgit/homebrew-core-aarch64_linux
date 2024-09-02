class LunchyGo < Formula
  desc "Friendly wrapper for launchctl"
  homepage "https://github.com/sosedoff/lunchy-go"
  url "https://github.com/sosedoff/lunchy-go/archive/v0.2.1.tar.gz"
  sha256 "58f10dd7d823eff369a3181b7b244e41c09ad8fec2820c9976b822b3daee022e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lunchy-go"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "df19bd9811d01cdff3a4b9badeee35c17d064a6d619dfdedfe0da3f06236a88c"
  end

  depends_on "go" => :build

  conflicts_with "lunchy", because: "both install a `lunchy` binary"

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", *std_go_args
    bin.install bin/"lunchy-go" => "lunchy"
  end

  test do
    plist = testpath/"Library/LaunchAgents/com.example.echo.plist"
    plist.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>com.example.echo</string>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/cat</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS

    assert_equal "com.example.echo\n", shell_output("#{bin}/lunchy list echo")

    system "launchctl", "load", plist
    assert_equal <<~EOS, shell_output("#{bin}/lunchy remove com.example.echo")
      removed #{plist}
    EOS

    refute_predicate plist, :exist?
  end
end
