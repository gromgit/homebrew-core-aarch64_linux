class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.156.1",
      revision: "5e1ea32203c719404e83b06ab21dcb1d9ef18530"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8124c497124dfdd5b0bbb3eb612d7cc66d39adb5a6fe41c7d75904f35666d3ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "646fac45e3591daa629b10d90cd3d7d9739327f1d8cea92dbac5b98c3511a9da"
    sha256 cellar: :any_skip_relocation, catalina:      "367ecea18f469d7245657314219b807244cb7bf34e2f0b04f3872007f8d48aa7"
    sha256 cellar: :any_skip_relocation, mojave:        "0f5c77f3a644ba4816dd3e6a61804ea73021c75b0a38a238e903e326e3d96894"
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
