class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.19.0.tar.gz"
  sha256 "8b162800b03be04bdc22b83c05d3a1504cb2f2f7d97c84a002e9f503be54024b"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2adecaec6d8630f75e8dbb0ae234b0adcbb3149efa8ac5ae49da9f9a8dae17df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb0e57d9ddbc83f7f355748183b8aea049bd3b7bc8a4aa89907b72cecee32107"
    sha256 cellar: :any_skip_relocation, monterey:       "967a2da3ae6f632f38a6406d4605cc2b78cea63ff8ddb71f00fa1d440aa751d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "30061e26530637c5848fc199fbb29b8b0fdf10917dc1cca19214efbd65b65c7c"
    sha256 cellar: :any_skip_relocation, catalina:       "77d60c61a0340925ccb5f22131a29eac6aa8fb5ea94f26b45ca4c0b2dc970141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1235de303770c4a1923aab01c37791f47d5f4854a0f3a16b740e8d820b1c567"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
