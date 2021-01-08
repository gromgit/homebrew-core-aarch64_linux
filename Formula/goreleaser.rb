class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.154.0",
      revision: "e8ea231122dc98ec2315eff2df2defc5191764d6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "54a3c738dc1a4d2d38846cb37798cdabfa4971d4aabfbc4ab17b2b21592fb0b8" => :big_sur
    sha256 "2066bfe0d204db59823c3599911026fd39bce0580573fd4cde9d48cca2640036" => :arm64_big_sur
    sha256 "0dd3cc56c2e263fb6f6072b6ef52b0c254da980e312f2fbf38110c9b33249b3a" => :catalina
    sha256 "4b4ceaab08741e5e5acfa6a12695894387b9e431bcba668cab38a5e3be3cae4b" => :mojave
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
