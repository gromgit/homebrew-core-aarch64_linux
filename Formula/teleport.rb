class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.1.3.tar.gz"
  sha256 "915a3846f90e36d0fb88633b4162e7d71713f32d171813517b3c2cc305fb5f20"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93b8753d88e3d5bb0d1c0213f16ffa6b695a690271be69074f149883eb6ebe3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cbd4c6215b5079ccde46d1ddf961f8a493b1a5954a29a1f11c28cbdbe06333c"
    sha256 cellar: :any_skip_relocation, monterey:       "00812929dcdf441fb56a5635016015bdcf0bb70082670c8bf29025f798c8ec84"
    sha256 cellar: :any_skip_relocation, big_sur:        "76554c3d41d77a60d56dee5e14a13c6e6e7e9caa399bc5b612b6ab8369281a52"
    sha256 cellar: :any_skip_relocation, catalina:       "374073781b5456aec688edc724a11b700cc6c414a1657af90c1c6996f88ca87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b95e1e0223d7304de434f5574c236fec38d8eaaf4d71761e5a11940a1142004"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/7f1ab7af27ffc36dea3b307312c1609996498751.tar.gz"
    sha256 "504dc02dce8ffaf5fab2e564ab99395ce760469e7b7c1634cc0dda5ab8723a95"
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
