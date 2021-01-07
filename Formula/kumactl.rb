class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.0.5.tar.gz"
  sha256 "ce9c56e730d0b2f76fcb6113677df60a84680eb05edaf5cadf956841410a52dc"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "07c3db478d2647ba2af17159b5d7a1e6f196ab1b52af92092b40dcae5ebd5aaa" => :big_sur
    sha256 "44ee98f5f6bf76dcd4450697f81a615f13af6b5b8e15c770b3280eb6146dcc6f" => :catalina
    sha256 "136517650e30ec372f0b3a930f1da8f3b711756d593fe39a51ea733c18a47d6f" => :mojave
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
