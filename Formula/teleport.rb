class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.2.0.tar.gz"
  sha256 "bf479d580dc0f9187493645b6e3aa7e5458e46ff4c632169fc688946a6265ba2"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30d706bbee3422dd6960b9ee70ce054ed0f64f5fa5c13eb791b243aedf750ac1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba3a1eed0ddf32e479f0baf0dc8d68d767cb3faca83944d359e8c88ca11d17dc"
    sha256 cellar: :any_skip_relocation, catalina:      "f16757dbbfb0d85f4762784a5b89780b1793cd8deda19bc0b4065453e9fa5f8e"
    sha256 cellar: :any_skip_relocation, mojave:        "9d0c63913bc32a5e8182112e43305fe0a3b9f41a42273e2a2fa518e13219a6d9"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/8c2812c169fa6bd5f31c13160bd93ef8b317bbc9.tar.gz"
    sha256 "14445b0864d759347c1f53dc144a346b1974b8ded49031d7f0b7227f5d49d407"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn("#{bin}/teleport start -c #{testpath}/config.yml")
      sleep 5
      system "/usr/bin/curl", "--insecure", "https://localhost:3080"
      system "/usr/bin/nc", "-z", "localhost", "3022"
      system "/usr/bin/nc", "-z", "localhost", "3023"
      system "/usr/bin/nc", "-z", "localhost", "3025"
    ensure
      Process.kill(9, pid)
    end
  end
end
