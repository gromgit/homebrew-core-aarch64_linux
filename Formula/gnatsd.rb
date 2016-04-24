class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v0.7.2.tar.gz"
  sha256 "f71d77ff31fc31770cf8e140d084ecfa91f7a8333f945bac1ff44732901680b5"
  head "https://github.com/apcera/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0df1d80f0d8b647935b0b6b9e579d9b7dafd4ff751c0e99828b23e2c27f4a785" => :el_capitan
    sha256 "ee8ab1c106c5f6dc9528b8097fa66deb9e0395ba254530b01df6c46693f796cb" => :yosemite
    sha256 "bc64bb2a8bd66f670f2a0b3989d1b38ad009c934db372b53f95819e165217578" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/gnatsd"
    system "go", "get", "golang.org/x/crypto/bcrypt"
    system "go", "install", "github.com/nats-io/gnatsd"
    system "go", "build", "-o", bin/"gnatsd", "gnatsd.go"
  end

  plist_options :manual => "gnatsd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/gnatsd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "gnatsd", "-v"
  end
end
