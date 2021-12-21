class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.0.7.tar.gz"
  sha256 "7efabc5808e246e1509b884ef5b9763a8c344b42f940e59e5b26eee73febdd6c"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af350423a3d32f2fe68c7ce998f780f7166109eac254c2ca702d051aadac369b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fc0455a037cc8ba0578b7d1ab68e7a83bc71e8e965eb9343cae4b2e35f7da8b"
    sha256 cellar: :any_skip_relocation, monterey:       "49b74e9f3823902d872058a9f4fe7c0cdccde4c91973344bbe06dcdad255f5fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd171ef199cc834f12d88e8521f3dbea2e33e9764753a1410fa03afddbb82286"
    sha256 cellar: :any_skip_relocation, catalina:       "389a808a7b499c2f9a848d3e9706db119bad909038c33fb08e134980ed28fa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f918ae23e691ca7377eb685ef05161c62bed5b221e447dc3df25635abcdbc6f7"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/240464d54ac498281592eb0b30c871dc3c7ce09b.tar.gz"
    sha256 "79fe6b28b056a1fff41123dcbbec5cad67382cc83c8f67484c4ba37192b8dceb"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
