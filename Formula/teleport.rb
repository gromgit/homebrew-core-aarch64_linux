class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.1.2.tar.gz"
  sha256 "1dda896d678fb7b6dfd7f9670f40b9cbb2e5f23f23646f37c0aa5558d3c54497"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58bbfaa1ff41f551ada1991a137093ccec01d3d532c745f90335580a2a22fabe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e726179634fa698d0b0a53bba15a0a23597f3066a5534b4184da60e620b688"
    sha256 cellar: :any_skip_relocation, monterey:       "f51727436c25142819843de55c03f65df98a8b5abd1e1a926014ea5551506a8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "65ea2fc17b45d243b2f60903f16a2d27015da90edf80206ea99d361d1aa9de78"
    sha256 cellar: :any_skip_relocation, catalina:       "f0380f814ad0449bc35b139b29c44828009a06569443cbd36d407e42e8e3ece4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e07dc85ee1afdb18a2d7f3ed474ba25a557bfbfc9124cf1304468ee238d99b8"
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
