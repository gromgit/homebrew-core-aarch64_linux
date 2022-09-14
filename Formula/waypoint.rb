class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.10.0.tar.gz"
  sha256 "2304f3e48dab78751b5307c6be0fcf9efffa434042d9debfb28434ae05cec097"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04fb50950cbaaf5b84607b4b2bf374180ed24cdf46ea0319ce8c3246ae118fd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc17466aa6bbdec8172242ab668e52c6161079734c413942685d96f58e049b32"
    sha256 cellar: :any_skip_relocation, monterey:       "a8cbc1ee8ab768878e4bf6c5aa79a9db2917272c00d010b93ea6a9c8e71fa9d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a07000b5ab14633d282b2a5d14a215eba6deec85cd54da7b398400287d4485b3"
    sha256 cellar: :any_skip_relocation, catalina:       "a0e652fc8315980004941a1a1e491bf20e9d2e01d22f4d48f196a9ade459b6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3dc17ab702bec0b4a473c27b5628cf486e646ab318b8f191144adf827ace2e8"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    output = shell_output("#{bin}/waypoint context list")
    assert_match "No contexts. Create one with `waypoint context create`.", output

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
