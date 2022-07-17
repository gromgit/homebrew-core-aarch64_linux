class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.0.1.tar.gz"
  sha256 "8089d29aec84d8a09525b7455c77f4e73fc3cc2188b35a8e40a698e65a0e7c8b"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9773c42fef6b65b28a553e1817748cf5c4bc86be245a584764dd6a496f43c38c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59db288f8c7c393c4ecdae2c5fc6f720cb350bd4dca55502c8e617972df6d2da"
    sha256 cellar: :any_skip_relocation, monterey:       "ec57fc75dce7a471bae73ccfd1f948c0c0bd1c8764f37193ddf34f4fe1126b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "27baba957fd4ecabe80655044d4c49b4f5d20c780a2709736850bc61dbb6d0e9"
    sha256 cellar: :any_skip_relocation, catalina:       "d0cce433c6e260c7fe7eee5cf5134a714868125c2c4ecaff48e2802da8b491b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af1c9e768cb83faf1a8d1a18fcb2374b735c4432cac1cfc3230bf844520f8638"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/dae01015ca8e1310734e92faadd13e77844b7547.tar.gz"
    sha256 "9e15a80a055c0496bab93ca079abcd9ddff47eb43b4ebbb949d2797fcbbe3711"
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
