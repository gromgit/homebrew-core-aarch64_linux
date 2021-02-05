class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.7.0.tar.gz"
  sha256 "ab396a2f156e92fb2215905562f062ee92f96abd8a4d979cfb8c63940c8d5f26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "217cac47e47bcd4d47b5244302681524ad9dfce9943e87c4bdbf6faf547ebdb8"
    sha256 cellar: :any_skip_relocation, big_sur:       "62cf4d646d1f983ce86d09b4bd86cd1e0dc43c98337e1fee7bfc10be89cc7478"
    sha256 cellar: :any_skip_relocation, catalina:      "074c38844fc3561734304ee2ef7e6529bbc7b331c561a7bb1002b0838074b3a7"
    sha256 cellar: :any_skip_relocation, mojave:        "4994184d5c9bcdb44eed93aca8441c7e4b7d25effa6c9c2181c3d2d4758c5569"
  end

  depends_on "go" => :build

  def install
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
  end
end
