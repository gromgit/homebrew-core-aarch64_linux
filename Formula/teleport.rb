class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.1.1.tar.gz"
  sha256 "fad1e36680c255d468aa600c1f95adee1dc02bc8dffd8518d07ab3d96a6488f1"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7571feb712f570ff192ec3bc1b912ac1715e7fc78759fcb11e927f85af64b2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e2c92c9fe8a645ab37e46392741b90f92fcb617e43242194ff0e166a1e470ff"
    sha256 cellar: :any_skip_relocation, monterey:       "064338ca0dbf799ae1e73e809e1fd1a4582a62a0f30630fe2434073de276f7a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b1cb1013d76432db0e114bc4498aae0fccc3646dd3933db1cbbbca8ddf60870"
    sha256 cellar: :any_skip_relocation, catalina:       "2bf6c18b1271e2f9c87760adc247b97723d6b1be980b884a839e253e83c9fb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdcca6b90c1644aad6e4bc64aafe004684dfdb305f7d9df1e69a9a52740e4e00"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/67e608db77300d8a6cb17709be67f12c1d3271c3.tar.gz"
    sha256 "e3a9db995855cadddceb52e047b639313c83d342e50b3b95627cc682534d9fd9"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    webassets_version = JSON.parse(curl_output)["sha"]
    assert_match webassets_version, resource("webassets").url
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
