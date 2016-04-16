class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.7.tar.gz"
  sha256 "5c838059826d6cde1183554701d3af93619980c299fe9d1365588a30a4ca6cc8"

  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e588b72b8f5cb8424a9051b3cf605dcb135009a5c497f68d2837594da981153e" => :el_capitan
    sha256 "9205a4f52701c711087ce698af69bd995f719c342b2ba9675cad12779a85cf67" => :yosemite
    sha256 "e5fbdaff63cb5908702c76f8dcffd08d2811f5cb5432b1bf8931af9eabaab84e" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    system "#{bin}/fleetctl", "-version"
  end
end
