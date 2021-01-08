class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.154.0",
      revision: "e8ea231122dc98ec2315eff2df2defc5191764d6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "50e7d5997d9e7dc20583969885dafbbec85fbeae733232feb49219f5df7163a0" => :big_sur
    sha256 "a1d96297b63e7372d082e750d08fc45f4d8b2ccb14cd1755eff442148da9006f" => :arm64_big_sur
    sha256 "ee5db7c6ea67d0925f8f88a9930b9a925d45e7ac6102f7ae18cd5154196d8c2f" => :catalina
    sha256 "923a80f28f496a69b5aaa70de720a37c1d70c687d48a4e2d861b4c2f2f6e05e9" => :mojave
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
