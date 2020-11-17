class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.0.tar.gz"
  sha256 "bc174a0b7fd4bc2f092e62dddffd964b1ec252440b3c331a781497601fa91796"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b955f427a76e3cbaabed3a14a697b3554d3e36d06d6d8250e1fdd8d335efbf39" => :big_sur
    sha256 "fd63799dcf686c38fdcbffffd55c82aa8e2628deb56f56c0080d2f5ba17351f8" => :catalina
    sha256 "932dc6e0d7ff70078f86d3fd846b3d275fa3b4966b0d424dbc1ed1d79cdfabab" => :mojave
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    outpath = srcpath/"build/artifacts-darwin-amd64/kumactl"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl", "BUILD_INFO_VERSION=#{version}"
      prefix.install_metafiles
      bin.install outpath/"kumactl"
    end
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
