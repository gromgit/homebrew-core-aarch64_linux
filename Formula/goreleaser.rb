class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.155.1",
      revision: "a816d969c9749c18ed6d315a4c4bd65698fe7754"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf16c319307c60e6e8b343e1e3da791de0710a8032f04c49464a5db024588c8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "56eddf68b2620b076c205b6a0f3095626693a2ec4cc3cf2b503481aca2b24413"
    sha256 cellar: :any_skip_relocation, catalina:      "5d8dd0e2bbed22e34edb5584baceedd0cda922a87aadd84397fc04ae2e0e1cb7"
    sha256 cellar: :any_skip_relocation, mojave:        "45241b9524053b1e3b89c4a98eb0f856ec51a16f456cc5718fea9e94dfdd7313"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
