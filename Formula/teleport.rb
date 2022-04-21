class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.1.0.tar.gz"
  sha256 "2f76403e800f60e127a8ffb6b57582233754f3d81b756f966d3b76f15ca8171f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fea645ba8486a6ca04e26a8f94f9136ac272021d4b3fdd5529053ae6071fecda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7aa051addfa1019f7e0c3f2a722d1cecd647c5fb9efbe500fd5c604a31d41ef"
    sha256 cellar: :any_skip_relocation, monterey:       "bf55605ad109b388895329958a0659be077fd1c9393a362564fbdf83869c4d43"
    sha256 cellar: :any_skip_relocation, big_sur:        "886dfa8fccf36827705b16a79ca9a2f2bfc7f9fc2747bc0b4898a98ab922113e"
    sha256 cellar: :any_skip_relocation, catalina:       "c3680b71b3fd9ee5ad4b82e0f523b34a74b3a14d953bece6e7c18b54eac6ecd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9233880a387c48c747a90472e11128fbae543ee8d622df85f8e5d4574533b7b8"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/b26c8f005e371e313193d4996625459c6968ea2b.tar.gz"
    sha256 "faf11bf286d1ff7d1e637208b3d9a9d6074a7669c522b69c228232a58b791eed"
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
