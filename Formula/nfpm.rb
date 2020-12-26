class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.1.0.tar.gz"
  sha256 "68109a33f4355f18a08736e26a31d35b1bc696065690a93ec38baf0c640c72b4"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "982e6fff6ef810a0c34621f4265032c59944d3a8e0e65f38aaca1bfda9f86576" => :big_sur
    sha256 "bb3b1fb3e4ff3611fe75fdac78a1c5dd78171724df773237d269d2aa7758995c" => :arm64_big_sur
    sha256 "a0e8dab8edc472bfc7c2b626bc129782439150eee3d81bbb690818a4a6d64af9" => :catalina
    sha256 "a28c0a29fbab43f958f92997b7ae9061a8715f58da7bb1527e2d8624a6451dbd" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=v#{version}", *std_go_args, "./cmd/nfpm"
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
