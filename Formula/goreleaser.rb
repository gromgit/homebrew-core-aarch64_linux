class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.156.2",
      revision: "43fcfafe7ae7633c9bc0790088d1da22613d43b1"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7b009eabd1a37ff9232d4cf3d72e1f06ebbbd371f3226e473764db10005dfbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ee8097cfdb031d05222c25d252fa777c0dff2d76b95ff194ff50ce8158fda93"
    sha256 cellar: :any_skip_relocation, catalina:      "c25d946767e18397a77d01fc179f060d358fb0733a3f742ad1d053c1f29005e0"
    sha256 cellar: :any_skip_relocation, mojave:        "bdb6912b68b2355027de44aeef1c8e78c2f7f45e57773455df7f61f0fda7f5bf"
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
