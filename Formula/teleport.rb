class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.3.2.tar.gz"
  sha256 "e830ceb17cd27b61cb50f1aadf87697179f714b2f9ff81fff0746b41c9d70845"
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
    sha256 cellar: :any,                 arm64_monterey: "b9464d2d0014b41691c38591c20436c066a63f7bc59f9b682b03cae4e7736e13"
    sha256 cellar: :any,                 arm64_big_sur:  "ee0b44f52867c0b1cd604ba9aeff75371b88a202aa23e22eb961651ef7473ee8"
    sha256 cellar: :any,                 monterey:       "971f976f40ce6c9dc3a176a0a1e194b115b94dd4d52a4f1018c1d7a26c37afec"
    sha256 cellar: :any,                 big_sur:        "d94e4259bca60f964aed4dbb4f56ce8587e4688eef86d7b1d2dfc0b5aae6cb2f"
    sha256 cellar: :any,                 catalina:       "09e508d63dac34929587d250adafd12b8c36b72e2ed51c47f3a0b15397c3e8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4f900afaace691d303ce9aca6b5af9ea61682eaa06abf11a8fa6fd4f075ff71"
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
    url "https://github.com/gravitational/webassets/archive/c4f689e451bc0b389ec3b8833b33997fa55d949c.tar.gz"
    sha256 "6df41b234508bdf086cfb523247397a0b1d54642fe8d18a09d5a9353d1cbb67a"
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
