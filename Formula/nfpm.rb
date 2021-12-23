class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.11.2.tar.gz"
  sha256 "a76e4cb2900a29ef75c90f3cbeb62ae2ae78d93a9dc60d7f113e5d6f2c67794b"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cae98a8ae3cf7e7e9f490f936944a7f3c1540a076bc9818b1588e2e882b39cfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be1fb5565c6d62d857bbce6585517002c00982cb0e4ffd21f5756c889015ff34"
    sha256 cellar: :any_skip_relocation, monterey:       "9a04879b95a34463ecfa96ad6a9be7cc3b46c608fb04e6fbb6134cbe868213ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7963eb5b7dfc1c73575c4bf1691ce7cd43feee3b3d1f27737395d7cc5698c78"
    sha256 cellar: :any_skip_relocation, catalina:       "47cd6f00d735e4853258a21280b3a5196f184693f95b68c3b7a14b6152842d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327c3b81bb666aa7cdae369933b9090844e45979949f6ecce32a3b409cff4ee9"
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
