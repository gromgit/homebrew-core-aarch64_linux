class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.17.0.tar.gz"
  sha256 "b1d909c4eff0e3355ba45516daddef0adfa4cdcd0c8b41863060c66f524353f9"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/container-diff"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fdedf4e9066f52918e2de230790119f83afaee312404c9a51d530219095fb336"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    pkg = "github.com/GoogleContainerTools/container-diff/version"
    system "go", "build", *std_go_args(ldflags: "-s -w -X #{pkg}.version=#{version}")
  end

  test do
    image = "daemon://gcr.io/google-appengine/golang:2018-01-04_15_24"
    output = shell_output("#{bin}/container-diff analyze #{image} 2>&1", 1)
    assert_match "error retrieving image daemon://gcr.io/google-appengine/golang:2018-01-04_15_24", output
  end
end
