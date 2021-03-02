class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.18.0",
      revision: "ec61815d60f66a6e4f6353030a40b12362557caa"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d5088905ccd94c85bb0265c4d3f8d66678d6397cd95323a6379db5c1ec771fff"
    sha256 cellar: :any_skip_relocation, catalina: "56cea9b07d67f4741835b9cca505f9b87402a1fff3d633087c0546fcb536622c"
    sha256 cellar: :any_skip_relocation, mojave:   "b1b36fb5e7c5ca8549375e48476ff63b3584fdfbd140a3d76ce1c9b5bb74730c"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
