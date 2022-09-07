class Pow < Formula
  desc "Zero-config Rack server for local apps on macOS"
  homepage "http://pow.cx/"
  url "http://get.pow.cx/versions/0.6.0.tar.gz"
  sha256 "225e52bdc0ace5747197a5ece777785245110e576a5136a3d17136ab88a74364"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  # The related GitHub repository (basecamp/pow) was archived sometime between
  # 2018-06-11 and 2019-04-10 (referencing Wayback Machine snapshots)
  deprecate! date: "2021-04-21", because: :repo_archived

  depends_on :macos
  depends_on "node"

  def install
    libexec.install Dir["*"]
    (bin/"pow").write <<~EOS
      #!/bin/sh
      export POW_BIN="#{bin}/pow"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/command.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Create the required host directories:
        mkdir -p ~/Library/Application\\ Support/Pow/Hosts
        ln -s ~/Library/Application\\ Support/Pow/Hosts ~/.pow

      Setup port 80 forwarding and launchd agents:
        sudo pow --install-system
        pow --install-local

      Load launchd agents:
        sudo launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist
        launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist
    EOS
  end
end
