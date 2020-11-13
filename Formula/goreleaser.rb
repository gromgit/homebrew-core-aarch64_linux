class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.147.1",
      revision: "40aa04fe714850150f76a61a9d311886ade74d7d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0c92e03bf36bf48c514e5d7273e4969d51160ed525b6f23ee4a38a139e6f4ee" => :catalina
    sha256 "2152b71b34b746740fc97f75f23227837ffcc9d8b60543f2cc1209f04a2494e3" => :mojave
    sha256 "ae0781e86599b52865232f06d200c67e7296c2327504231f1f2d2926aa60f26d" => :high_sierra
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
