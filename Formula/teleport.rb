class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.1.3.tar.gz"
  sha256 "4c5ea6d06f7f74d56163278ae773ea31ebfef4ec5516ff0ee70269c559e724f1"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98dab143c67b41aa12762ae85b2c8557e25e3e4bdb5f5e354ec2c1696bf12918"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c4f3e52b7a5e5456a09498e62f7cc652bc459d68d70c402ce27da9a9bd5b0d2"
    sha256 cellar: :any_skip_relocation, catalina:      "f1c50312bebf6df41fe150eaf756045d8851d8988e0170b46032831b6e38be93"
    sha256 cellar: :any_skip_relocation, mojave:        "48e0af7c38a43bd075cc22a11226959189f427ad519160ac00c2751594bd2f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6daf2c2bcf21c36b9b9c7c6f25e1aa031dd6f6644aae731f2847363d25798b6"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/07493a5e78677de448b0e35bd72bf1dc6498b5ea.tar.gz"
    sha256 "2074ee7e50720f20ff1b4da923434c05f6e1664e13694adde9522bf9ab09e0fd"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")

    fork do
      exec "#{bin}/teleport start -c #{testpath}/config.yml --debug"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"
    system "nc", "-z", "localhost", "3022"
    system "nc", "-z", "localhost", "3023"
    system "nc", "-z", "localhost", "3025"
  end
end
