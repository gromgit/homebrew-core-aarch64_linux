class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.2.0.tar.gz"
  sha256 "ea986a7d06a9b8a2cc2bbd479d5a65614bea2ec33e89a3d5d802255bd03356e1"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8dcb61429f5420c366a44f06dc93ddd9a85e32f8646e0e71c7b633adaa621b6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ec6b1262a62ee796874416cc20b1dec71138e45b5cfd82a1781ea58b8d148df"
    sha256 cellar: :any_skip_relocation, catalina:      "1adf6ea9637e5ecedf5244f3699d4358ec59a79e21dfcd14b35ecc134da4a1d1"
    sha256 cellar: :any_skip_relocation, mojave:        "a30fb99e5950dfd46ea2dd78178be7ce47110d03cad4376bcb69704e86b9cb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171a240fe7cc65dc0f655673f13fbe1a8fd45571ba1cc21830e1e3b9d21d2880"
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
