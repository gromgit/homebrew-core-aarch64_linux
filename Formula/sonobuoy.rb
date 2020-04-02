class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.18.0.tar.gz"
  sha256 "8333e5af4483b154e339de168e3fc67d296983fb480a5d3845e8c78cfb9fbeee"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fc37828c22f9487342f0619f856a9c52877fd2537a552fec0fec2e38a153db4" => :catalina
    sha256 "73954da6b69f734a8788d03f37dfcab0c5e675126db9e7c3c86a0efdf3bc27ca" => :mojave
    sha256 "be5dbe3b8975ba301fbe94033e78df80fa4dad58e108e893d0b2b1438ca4a650" => :high_sierra
  end

  depends_on "go" => :build

  resource "sonobuoyresults" do
    url "https://raw.githubusercontent.com/heptio/sonobuoy/master/pkg/client/results/testdata/results-0.10.tar.gz"
    sha256 "a945ba4d475e33820310a6138e3744f301a442ba01977d38f2b635d2e6f24684"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/heptio/sonobuoy").install buildpath.children

    cd "src/github.com/heptio/sonobuoy" do
      system "go", "build", "-o", bin/"sonobuoy", "-installsuffix", "static",
                   "-ldflags",
                   "-s -w -X github.com/heptio/sonobuoy/pkg/buildinfo.Version=#{version}",
                   "./"
      prefix.install_metafiles
    end
  end

  test do
    resources.each { |r| r.verify_download_integrity(r.fetch) }
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.14 2>&1")
    assert_match "all tests",
      shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
  end
end
