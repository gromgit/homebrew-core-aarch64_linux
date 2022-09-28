class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.2.6.tar.gz"
  sha256 "85090cbc25ff0d415488c5dedfe2f4c40d1b72b8ee5c61eda11ee14b71bce314"
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
    sha256 cellar: :any,                 arm64_monterey: "fd7380c57d2c6fcdc074311c104a5e00b73d5137d0716964b92344ab85e6fb35"
    sha256 cellar: :any,                 arm64_big_sur:  "87656e79beb5a17be9aa32e275e49f36ef23f69cac715efc7cca79c83e3720ef"
    sha256 cellar: :any,                 monterey:       "9c99969dd90e71974077655d5969879efa235f8554b6e0146a681f2dfded9ba3"
    sha256 cellar: :any,                 big_sur:        "0a6138315078606e02c255e7e4fa0a9919ddc91f215ff4bc5f7f9c4c077aa022"
    sha256 cellar: :any,                 catalina:       "ed2e689a20b5a3cecb8bec0e04a413e214844691339ee583ced636e203e4f66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea4b30f5b8cdbcf92ae54b4a32996f4a1f4141a8548affe3ca03f69b64da44bb"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/26739c9dc5f83569886296ab176b258f07994d1f.tar.gz"
    sha256 "412989c41f2a4861be8716e785f16a234ab51e780b9c3665d2953b05370253f9"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
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
