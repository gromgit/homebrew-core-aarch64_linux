class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.1.0",
      revision: "a23afae930033c22438008c1f730f13c7408d951"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11074db63d63e06de1d07e1996b46a8b9c1101174da38974cc17ed7b059e88fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf572cad0b85d05813d5ac7292756a5525998bb4b486c8cb1e3df4caef1c01ba"
    sha256 cellar: :any_skip_relocation, monterey:       "080f4e0b2841af610913a460cf75b8299ceefd76fc5fd7e3b4ec20fbf95943c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a133be8b3d0e388487f1309d77c44cf053067239af16f7415f512e7fb7cbe8f"
    sha256 cellar: :any_skip_relocation, catalina:       "1a510cbf17d29b0167a30955e2897d4598aa8b71389563285ff32d1deb9b049c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bfb9e57efe7df8dda8af8184defd6cd1fa85abed46d1c57bfda3bb748fee3b1"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
