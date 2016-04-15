class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/releases/download/2.1.1/charm_2.1.1.orig.tar.gz"
  sha256 "bddf10c43eb0fa85da575d39d46f2041b2396c63351cce2cf8e2d6c271c7cc47"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f89fa2ab05754e0a813caef93ed739af18e96976fa2faaa83f5d4a8dc1ff39a" => :el_capitan
    sha256 "290e13e5e9d0cb573b4bb2cd1d974b570145e9eb7fbe4988417f590df6c28622" => :yosemite
    sha256 "0d0ec0323002d52cd1a148225d3876dc36f04e5ca40ed0b324ce888fb05d06f8" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/charmstore-client/cmd/charm"
    bin.install "charm"
  end

  test do
    system "#{bin}/charm"
  end
end
