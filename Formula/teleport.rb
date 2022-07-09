class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.0.0.tar.gz"
  sha256 "17c7aa0102566d1a0a25a483c068267cb5709eb87e5353412a7433ff2cfa0c51"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d58b671bd6c71aecfdd8b588cd97b7828f90651b52a680e73a49e9f37b8cec61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d5f4bb6393081af66576a929e2e81a4902b754066b2f586c6cafa63e4ab02d8"
    sha256 cellar: :any_skip_relocation, monterey:       "0b14ab6834f6285833074e0d07978dfdaedab7c413ee3442a41668c5ab43c548"
    sha256 cellar: :any_skip_relocation, big_sur:        "04fc4e0e8eb751774448fd89716f05e07824886638648b3279c75bd750f59389"
    sha256 cellar: :any_skip_relocation, catalina:       "aafd0b4ba758363888e3e7a2d669b6556d3c36be87dd29c60e3b6db10bd5f4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c9b2fb074dab6bfbeb087f3e75de4e76b6939e0b0144da542240e80ccd17cd9"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/b7c202ef70280c0aae47777e275925c52f23139b.tar.gz"
    sha256 "73f0309332cbb0511d1c8068f0862f9a858ad9e7962426036675251e0884c692"
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
