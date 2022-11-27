class Vert < Formula
  desc "Command-line version testing"
  homepage "https://github.com/Masterminds/vert"
  url "https://github.com/Masterminds/vert/archive/v0.1.0.tar.gz"
  sha256 "96e22de4c03c0a5ae1afb26c717f211c85dd74c8b7a9605ff525c87e66d19007"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vert"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "376adbae6f628ee54a493cd86781eee1f8bfc840f03573433c1dc11191f25233"
  end

  deprecate! date: "2021-07-29", because: :unmaintained

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/Masterminds/vert").install buildpath.children
    cd "src/github.com/Masterminds/vert" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "vert"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/vert 1.2.3 1.2.3 1.2.4 1.2.5", 2)
    assert_match "1.2.3", output
  end
end
