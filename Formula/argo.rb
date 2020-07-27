class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.9.4",
      revision: "20d2ace3d5344db68ce1bc2a250bbb1ba9862613"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd3ec57664e6a9febeb2b46ed1819538f074219d9f91956a74617dc4326c7e4c" => :catalina
    sha256 "14526db90cf7076b4c365279e1f1ec31804bd7a18122008836f4ddf1fb72941c" => :mojave
    sha256 "a5d57bb86d96062ff009e4b179b253bd79f83fc79b4d64e93fe95d99b1f49ca9" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"
  end

  test do
    assert_match "argo is the command line interface to Argo",
      shell_output("#{bin}/argo --help")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
