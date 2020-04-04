class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.131.1",
      :revision => "dec22cf0c8a6464390ea26b42086d242e396ecda"

  bottle do
    cellar :any_skip_relocation
    sha256 "263b455bbea0b90f9eebaec62aebffca0637b99e93b2c779014a489fbe199a16" => :catalina
    sha256 "f86a07ce720129b867022ff382c2b4170e17f0a25e636fadcd5f9e5d89cb3a17" => :mojave
    sha256 "3088bc054a43b16bffc67ee2955577f1ff377b857ed20e0b55d4586ecb9d48e3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             "-o", bin/"goreleaser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
