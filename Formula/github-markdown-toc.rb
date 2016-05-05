require "language/go"

class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/0.5.0.tar.gz"
  sha256 "78ea87ab18fd213e52b217d7ec0bc4eb56a8dbeb2331b82376e6a741b0121d1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f74ddef6dc13984186533a00ce3fb5a91b1a12e99715b5f6224047a2d9d28d8" => :el_capitan
    sha256 "3f80c515b7e70ce59bd583ba3f61dab1e563c4b3032d6220ecda555fd1f3bfb1" => :yosemite
    sha256 "a46a542a52ce0e758f544e6ab1a5245683bdee7697142ad0159df8d4a74aa32e" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
      :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
      :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://github.com/alecthomas/kingpin.git",
      :revision => "v2.1.11"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ekalinin/"
    ln_sf buildpath, buildpath/"src/github.com/ekalinin/github-markdown-toc.go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gh-md-toc", "main.go"
    bin.install "gh-md-toc"
  end

  test do
    system bin/"gh-md-toc", "--version"
    system bin/"gh-md-toc", "../README.md"
  end
end
