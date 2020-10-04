class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.4.0.tar.gz"
  sha256 "72586aa8a07bcc3163d921c5b2afa0adec8688058f62801f1377a61a91573328"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4e2e346746e54ff6b612e9b632de739c363c4268eb88f0eeeec63a380443b5d" => :catalina
    sha256 "e7a1164c06c7f237c41fffdc3cd6ad7d93f9d7b18dd5fdea891f3ce04e251abf" => :mojave
    sha256 "41559e91e5218b4b6c3356502c4c006ed5cea510a6eaf96bbcbbaa4205abea04" => :high_sierra
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
