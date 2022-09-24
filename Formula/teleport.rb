class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.2.3.tar.gz"
  sha256 "a44a48ed50846687ff48c6e368269e980de38a4c5baec30b6ba844d9348bcff9"
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
    sha256 cellar: :any,                 arm64_monterey: "c168082d234718deafdbe085f1c46b9458088913d7c95c042cd11217a84083aa"
    sha256 cellar: :any,                 arm64_big_sur:  "c06de09cee7958335b3529d9bec2fb662c555b4a9d0c8dd079676725a03a38ca"
    sha256 cellar: :any,                 monterey:       "21e8d4a1b5040c228f09321ca737c49a950cd61783298b1c8f2fb17cd12e4d98"
    sha256 cellar: :any,                 big_sur:        "9a2e4d2d9760058f7136dfc58eef93578ec16aed841f215f10ad423d78b6d4a0"
    sha256 cellar: :any,                 catalina:       "8d75ba8a7241249321056c60d52edafb8d0d8789fd55140d2950f5aa9b50c015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc2093c169289ed325656036034afdc5341047357275f846618a0db53cb8dcd"
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
    url "https://github.com/gravitational/webassets/archive/52c71e0c587647aa07a91599f1b9204d577de271.tar.gz"
    sha256 "e2c021a28b5befa00a162fb9baf0930c626d62a2549cbb9589244225da931850"
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
