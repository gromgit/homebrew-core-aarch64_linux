require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.9.0.tar.gz"
  sha256 "bbbd5c472c36b78896cd7ae673749d3943621a6d5523d47973ed2fc6800ae4c8"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sift"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a0f3fcf33ba09f1c489c02dc312ba47b8a4666c406d3eee10500cc797b788b0b"
  end

  depends_on "go" => :build

  go_resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git",
        revision: "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  go_resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git",
        revision: "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        revision: "3c0d69f1777220f1a1d2ec373cb94a282f03eb42"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/svent/sift").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/svent/sift" do
      system "go", "build", "-o", bin/"sift"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.txt").write("where is foo\n")
    assert_match "where is foo", shell_output("#{bin}/sift foo #{testpath}")
  end
end
