class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.3.2.tar.gz"
  sha256 "637b571cb5bbb3d516481df1360c35a9c2e4223292a493bff8c8bf319eeb020f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab66ea5c3f96c33184d30a2f8cee064b5e9392f480caa0475cd6b86f941eedc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0066e5bcbc505ffa0e566a74ca04a30bdaeed1cf601b4e96fb92c19fb679bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "f5eb5f08b4449be163e74855ade1f0558ace859f549b1ab99620f3e9c21b353a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c8f030de14127e603e39f3a4ac8bd8c677fe84992c3c61fed3d3c91cf450c03"
    sha256 cellar: :any_skip_relocation, catalina:       "8a5972841e017b470cb54a163ba55baa29b1a4257e409faa9407e5a1e06576b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b28593d14df2c90de3336b2be47b20ea850b6e79468f6c8f72fe9d658f530cd"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/a1cf8bdbf418405bdd23e6431bc281b4f7cf4e55.tar.gz"
    sha256 "4724129da03a3801ba316c6f456cdb6a6e729831b610fdacffb1e421a440adcc"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
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
