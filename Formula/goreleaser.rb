class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.143.0",
      revision: "28230b67f8f25ed8493e85f3d06fb4dec5618f44"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ef7ca6765c61694e6d63c5e95929d2234480c7d75807ce68a73234b2cbc239d" => :catalina
    sha256 "d64c123992116544febbe08e0a88476b7b9e9ac320efad00d9760ad34c71e44e" => :mojave
    sha256 "fa1e0110c826109db418814d9c34827e41a7d1125a9cea5c28c0cebe427d68dd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
