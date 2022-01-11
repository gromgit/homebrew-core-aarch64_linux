class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.1.0.tar.gz"
  sha256 "3687343cf46cd9d03a38035f02f4d826945402fafa8fd8c2566ef8d413eea829"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4018acda088803f75ca3661ebf3919a1937959e9893cf840169cdc061a612704"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1698c8f5b2578782170168054ccdba82009ef3b6dc97f5dd69c62de5e29c2ec3"
    sha256 cellar: :any_skip_relocation, monterey:       "9364b6077be743fd49142cb31e0db1150ea97fbce85bcfcf8614f7ab154cd81c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a62b87f96a85cd4379f8ccd22371541b6452f369a524c634536ab445fa7dba9"
    sha256 cellar: :any_skip_relocation, catalina:       "be1d38c776cadcb1f366fc46a65436b56b835bc63d52eb5e8e5d16bd4628ef5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e79a20efc967f69f321718a570aa0e8f5a50beca3f25dd296da1a514e13b866"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/240464d54ac498281592eb0b30c871dc3c7ce09b.tar.gz"
    sha256 "79fe6b28b056a1fff41123dcbbec5cad67382cc83c8f67484c4ba37192b8dceb"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
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
