class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.155.2",
      revision: "a02c7386f946a07ee8c6b69d7a78fbb382e3b59e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9881d87423da12b429bd97ecbc2622e92b4015f86c82e352cc80aa57bedebcd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "860c7df9975df3f770bed267e67826016db7845b099a4474d7112b230793502f"
    sha256 cellar: :any_skip_relocation, catalina:      "b28ef5d17f2bec5491b5dd096579fd3a45f81324736ef15d45978faf1b0fddbd"
    sha256 cellar: :any_skip_relocation, mojave:        "834272bd276065e3160aeb2f4bdf5389c00237e2b3406ccfea71c8e58edbed86"
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
