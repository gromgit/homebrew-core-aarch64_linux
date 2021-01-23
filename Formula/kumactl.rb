class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.6.tar.gz"
  sha256 "3d93c7508174d456a1d8a50f64227d243fa1226f8116c3dac6c044b246698415"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a801c343df0573c1471ec24778a06dcb6e9da4585ef4fc2b5e8d80260c5ee6fb" => :big_sur
    sha256 "1c0156379e49a001bf41241e3158da4f2d789c587449589fc67c54aa3c018108" => :catalina
    sha256 "0f9d9bcc4803e182a9a4917006b39eeff36ee87cd67628557da78b39f4f74c48" => :mojave
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
