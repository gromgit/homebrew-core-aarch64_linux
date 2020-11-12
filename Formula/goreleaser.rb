class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.147.0",
      revision: "c39c8208f094ab854e4e7c8d70d8b74fef85fcb5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cd9e1e6d58f4c3a346014b32ea6594138b88ee7fdf23f697311e5c4933def78" => :catalina
    sha256 "64a4d5abc19b280f4f89255b23c8e20829537031f53735d072cc774c39c42c46" => :mojave
    sha256 "500cb940f36f11f82d635e4aa84f69c2e96993e24e294ba0badcee1ca278e465" => :high_sierra
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
