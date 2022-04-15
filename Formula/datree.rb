class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.2.9.tar.gz"
  sha256 "0774c51e3f90444aa7070f1f2ce2e5794db418573c28318e9fea80aab3d74e86"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5a98e9a67074ff780d754689fffcfdfb362906bb4ae4102e0af5d7b06d8377e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7544a1e843c0f4c39045da333c7dc974ccbcc670903096a1b85ce08d0e1f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "83df098a93f79897b35d64696246944dc1ad97c109a86bdfc843b084dacb4010"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2df16cca3f45a76987c57171cff76b5c6afcc278d1e6e7626793adecba12971"
    sha256 cellar: :any_skip_relocation, catalina:       "5888f2402dc879da6b8d695db1a82115782c4f138a6be31844b0db38c00e5ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733ddd7d58e5ba1ec37220fe04e1be907e1094d1a0425cef40bcd30122fb800e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 2)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
