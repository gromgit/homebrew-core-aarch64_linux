class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.2.2.tar.gz"
  sha256 "309a8760f1f329ab1a56a0ad8240e447e5bbcd60a7e1c7f9d24830ff10b89b84"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba07678fb6f5704777eacca77ea28f90fb1059e6b2dffdd7f0defaea83e85727" => :big_sur
    sha256 "98955879ccd8cf225f21d2545ffec231ef04f3e79ed82ef8baf86e57983f20d3" => :arm64_big_sur
    sha256 "64445d6f4557555b29220fc6ec2681aa31779d0309a62d2ef38490bd070afd1a" => :catalina
    sha256 "9ecf7f3bdde9c508bf68deeb9190e50e7112e5a22a3813f1b19d009db8a20514" => :mojave
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
