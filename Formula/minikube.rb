class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.27.1",
      revision: "fe869b5d4da11ba318eb84a3ac00f336411de7ba"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "639fe1f8c9866f06b2186b428d2a5565947916263d6cf6516c2d8b5798a18c62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41cb8cc8b782a6c1ce4be0157746ca72a9c4397922a196c2ab0b2ceae82c834b"
    sha256 cellar: :any_skip_relocation, monterey:       "1b4e3421d99cb00955a109590998580dcc2997efedd87291e2e113473b4dcca6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bc3992ebd7369ce2baba8cda158fab44ebf40348d9505ebe8525dc0ef7301ca"
    sha256 cellar: :any_skip_relocation, catalina:       "c24f39072fbfe2fa9e229510a482aa32465a3e00e4a7bc3baf065f6db543a6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9dd6dfb367063805057772e6d354979647f9d5431adae7349e3c1f80af9a216"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", "completion")
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
