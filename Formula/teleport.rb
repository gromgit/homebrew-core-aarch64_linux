class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.3.1.tar.gz"
  sha256 "1546a7ad535732fd6d6e80d54bca31b6f02195cf5f58b6930801a1b457d47516"
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
    sha256 cellar: :any,                 arm64_monterey: "91dfc3d9fe1ebf6432ba4fb2bf8f372a038ceaed7e8c44db0bd7f4a062aff9e3"
    sha256 cellar: :any,                 arm64_big_sur:  "8821d6e2de969da4e2a9755d0440cb51775519d549840a8090b5ad7d52e7a247"
    sha256 cellar: :any,                 monterey:       "3c282c50390f8a91a9f7b7119dee1426215ec47f9718bdbc15a73ba6dcd410dc"
    sha256 cellar: :any,                 big_sur:        "b04808bd916c835eafb1506b3cd621d4b2979be6a53ceb24b1ee42b66dbf8ef1"
    sha256 cellar: :any,                 catalina:       "c891c8d697e63cdc19269df2d15750861a063f68d016470dfffb32916662f714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089a69b2fdf8cd14fc64a2d21f283e585fce0585e1f7ebe976d942c06f0ad36a"
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
    url "https://github.com/gravitational/webassets/archive/6710dcd0dc19ad101bac3259c463ef940f2ab1f3.tar.gz"
    sha256 "29115a3be8f570dd0951484435fa56166d7fa352f18399e8d20f5ba8242f11f7"
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
