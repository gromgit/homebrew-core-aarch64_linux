class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.3.7.tar.gz"
  sha256 "63d0ba8756c013c9ca76a902561f8af56d8c9b5a038189d79725f951d2217a38"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b08dfecf46a7d50c52c9ca84db43626834cca37b8cec710137c134735a2210dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c67c71c863e1635da73ba081729a8d52cd358b0fdd56de3496c4b8deb4d9305"
    sha256 cellar: :any_skip_relocation, monterey:       "a545618228dd816204b0a775290fe9863cedf717ddffc87b77d2b712d238c65f"
    sha256 cellar: :any_skip_relocation, big_sur:        "002e13e62c9db720acdc495988d75f370082b8ad1a68fa037359ec0651ff64f8"
    sha256 cellar: :any_skip_relocation, catalina:       "890eca535a9a27540dd37f55600ed037b92165e686a56ed8f10ad41b4c72a31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "accfa4c0138fbd314b3dc36b15215ca289127683f7d60212500a42639de6d260"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/6e79f9805b7659b2d59bc4ba7c30a92072efcf7b.tar.gz"
    sha256 "305117f1162ac02cb65c28334f982f2bae4855c230fc471e8858950461cf05df"
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
