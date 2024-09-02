class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.2.1.tar.gz"
  sha256 "1fde014338e137cfced6ebb2661b55966264abc1a7624379859b31e3107a1f2f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21bbe32cb3bf50fe1134b1d7bb11669c19630ad79f3af4e5bb574a111abb7fc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ee99fa8ed60d134fd38c33c0cd97a0b13ac3a20e88202c7cc34a8c2273d6713"
    sha256 cellar: :any_skip_relocation, monterey:       "00a3bbde09eb86b688f3b47e2fdbc3918bc10c0d0d359806a084aa698aab2f88"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6db2dfbe8be5a208b59bab37abc135fa0d14f548028d45ec76920dc16c7318c"
    sha256 cellar: :any_skip_relocation, catalina:       "fce410377c9b9456fa14d6077cc0e37814d830d9aa1a1aa0eb27acf23a867483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b47dc4feb3746d7c027db6a84c9dbb2e00f61c97d40589c1c954ea847bf05c4"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/4c555ddd7f4e8c6d74dd1ac467db5d17ad5c4ecc.tar.gz"
    sha256 "00ba592b9a5f790e115d41a2a42127b178b75a362292b68b40577881a0984b19"
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
