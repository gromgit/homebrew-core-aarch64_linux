class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.2.6.tar.gz"
  sha256 "9ddd7240c9255b9ccde656126c2396b15b88d536d493a482d9a14c0fb165be16"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4877eaa3562a7833307882cb7cd1fc2b7fec7dc596bca8aef357c4680bd73aff"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b13c4efb0b960689b92dc5d7f3d6acac647530076414af3bd3f58e929aea4bf"
    sha256 cellar: :any_skip_relocation, catalina:      "f005ebdde5888db88e21e54fcbcc158cf3d9ac32339a84b1b7eb9d017d87c5af"
    sha256 cellar: :any_skip_relocation, mojave:        "9d88944c1693f7de8b79b4e7966b472c2a605a20cf5b26282049c09fd8be2f25"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/8a30ee4e3570c7db0566028b6b562167aa40f646.tar.gz"
    sha256 "54eedd358523526945d309f16b5c53787bc7a9a9337336661361385a6767fc42"
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
