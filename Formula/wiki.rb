class Wiki < Formula
  desc "Fetch summaries from MediaWiki wikis, like Wikipedia"
  homepage "https://github.com/walle/wiki"
  url "https://github.com/walle/wiki/archive/v1.4.1.tar.gz"
  sha256 "529c6a58b3b5c5eb3faab07f2bf752155868b912e4f753e432d14040ff4f4262"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wiki"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "03ebbf334cd47a3e0417df9276a235e8529933081b6eb0402ac05e4e591ed64a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"wiki", "cmd/wiki/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiki --version")

    assert_match "Read more: https://en.wikipedia.org/wiki/Go", shell_output("#{bin}/wiki golang")
  end
end
