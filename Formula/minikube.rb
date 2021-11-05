class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.24.0",
      revision: "76b94fb3c4e8ac5062daf70d60cf03ddcc0a741b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f478ab468080bd8d913c4045a8ee80e76a66b01e6c7e3ad91fa13f89b7855ed9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d070d46f911a23fa36f155179e9dd62c2a562d070d4a6c739978031a704cfd1e"
    sha256 cellar: :any_skip_relocation, monterey:       "059189a1c1cbde25bb420392acdda3bdef505b0fff871d58ae80165281d3468d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f123e76f821fa427496a1d73551cdcd5c4b7cc74c3d6c8fb45f6259fd17635e"
    sha256 cellar: :any_skip_relocation, catalina:       "faa91becd0ebb93d8af0ce849ff57516f3cb090a2c350b0b1800250729f7f573"
    sha256 cellar: :any_skip_relocation, mojave:         "0103f2958d7609a9157e7de9c69b24bcc86e858a912080063aec594d0e07fcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262e375995aab490eb42d8ac43304ed2b07916e6e82478bb68998f19268bbf0d"
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

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "fish")
    (fish_completion/"minikube.fish").write output
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
