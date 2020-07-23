class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      :tag      => "v2.9.3",
      :revision => "9407e19b3a1c61ad4043e382484fd0b6b15574f2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "605ef7527785d127af197e6479c6ea06f7d18770b420a11b784f9327d750f705" => :catalina
    sha256 "8a835bb7ce528c56a04b18dc7576e00243b2a0b1ececf1dc7fcf1b8aa9e5bdfb" => :mojave
    sha256 "659f4eb9b415cef16798604b23152a47e1bd12e222963e8a1af5aa05444e15a2" => :high_sierra
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
