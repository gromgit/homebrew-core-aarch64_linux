class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.2.0.tar.gz"
  sha256 "1e5fe7e9b3488f96d8006f1f6ba0d22efa33435695909bcb0eaa251f1f3b383a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efdfd0a00f512a4b8a86c376b1bb4289b80dd24f7a6c2d0644829392380cf196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cea024687a7680bd15115a71dc8aadad32786e0b08aede9ec43f986b073db3de"
    sha256 cellar: :any_skip_relocation, monterey:       "4478173fe6cbc730d54eee8610eb380082e718c162a61401b5017dc63a2a3303"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb8488f193c5b79e98c23719875ed38a2336a804b7bd22095471b6685491125"
    sha256 cellar: :any_skip_relocation, catalina:       "3057322a44bf9dcb79ff4d5fc3c0e1f94dfe3313d33d19af50abb2b8aac239a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f37ad568f951b4ed47cbfc7a0ae62eb12afa4a8ad481827fd552005e918985"
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
