class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.6.3.tar.gz"
  sha256 "dc18126137fc3f4ac3d7ef0dd50c9c905508f250004eda158b26a201b0c68ef3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dfc21ba34b838bd87b3846e4f8ee6cc0e1bb6ca9d8d18b1ee4f4a4ba99baff7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e2423eb1814d4fbebb839fbd468547d6d38b36887312bf866a8716ed0e029d3"
    sha256 cellar: :any_skip_relocation, monterey:       "700a542b4761ccaca3a306511b0e30fa959c221136ecc651d1612521cf423e54"
    sha256 cellar: :any_skip_relocation, big_sur:        "13e5d5eb373f1146c550bd2ea8517d49588b25732100aa64b1ddca2e8545ba2b"
    sha256 cellar: :any_skip_relocation, catalina:       "d3a0fb49494acb604d908ce662ce5acaaeb6afde8e5c87c5a349d99048bbd6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85957fa64ffe96ef0d4ea827f08d1f30ca0367b457aacc3fd267211256d34e6"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    assert_match "Initial Waypoint configuration created!", shell_output("#{bin}/waypoint init")
    assert_match "# An application to deploy.", File.read("waypoint.hcl")

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
