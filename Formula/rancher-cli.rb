class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.5.tar.gz"
  sha256 "538152806b030a27d81824fe1319203d0ff27f7c3487faf0cbdec2097aec6909"
  head "https://github.com/rancher/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb1c9bbde2479be996ffa2a0dd612a3b63868f31601e13f31e2f98504f970f40" => :catalina
    sha256 "517cfcd12c3676765052d8ca9633d631f55d9e006f5fd0c6721d108ac76c607e" => :mojave
    sha256 "cb1bf440ddc1852dd9d25ea69c90d2978e179e7a27aa6b840b65f33db397f143" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags",
           "-w -X main.VERSION=#{version}",
           "-trimpath", "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
