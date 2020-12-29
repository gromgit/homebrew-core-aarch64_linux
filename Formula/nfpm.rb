class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.1.1.tar.gz"
  sha256 "a9f95c91c01a0bebe191ce50d8a871f5c004bdafcab0c0812eb375882610fdfa"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9445406e3b0c61d1c64b3f89eb04064d03016e977d3ca28a45598c635e41e8c2" => :big_sur
    sha256 "d0c101c18722188e3e4e97c81e60147f7723c6611885db94f2de7f3abf9ae634" => :arm64_big_sur
    sha256 "024fb908b7acccd6464b05611b281d16861d7035373539cafb754f509ca61b83" => :catalina
    sha256 "569d5014a7aa045829e7a2ad4da23005303bce8c72d51f67d9f54eaaa28cc8d1" => :mojave
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
