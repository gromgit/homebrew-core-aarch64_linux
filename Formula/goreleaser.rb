class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.150.1",
      revision: "8e45550e5034325d9a5f6ac2b3ad08e9786eebc3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf1681fe79400c15578cb5cb144fa55b05b49c1033c5a5cee50a3299cca14f8a" => :big_sur
    sha256 "14142d10a07a4577b6e3fa544781c8112292c7095c4ddb546cf799c780a2aeb7" => :arm64_big_sur
    sha256 "233279814ac8f7578b03d93e354ebf9b77714216da6eec5ccee9c25b8a7a5d28" => :catalina
    sha256 "47ebbc0657f2457524af0457b050e34f142b92ca4c0f14f9a6d1aa13f659f632" => :mojave
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
