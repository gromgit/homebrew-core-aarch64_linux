class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.2.3.tar.gz"
  sha256 "3f116ed8ec6d23366bfc578d4ddfc5e43d6a8683300f6b1f53e57f4985ffc2f4"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4c8108b4cc7e31d60fcb92487232290be9b14c6a8dcb0e59b8c7db180413b32"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fa2d0cccf0f3bc2ae711cb1269bfc61ce57e02fadc7a8158e87258aee5c5ff8"
    sha256 cellar: :any_skip_relocation, catalina:      "3ea370c895d22e4f3e186052133ecd3c8616dcee775efb79e91ec2ec8eea47f4"
    sha256 cellar: :any_skip_relocation, mojave:        "f34dad9004387dc832ab3c45fb1c31c99eb55ebadbb282804434489c2e292641"
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
