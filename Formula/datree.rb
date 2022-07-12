class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.30.tar.gz"
  sha256 "b8f764612dcabaa38ec580e8ddd97af3a1ea347af2b3dc04ecfef8f7e86bb142"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4102310cafd5d3dc8c36659746f8433cc1a90bf25948b119422bbff4da20875f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c469f7b6cab05c17ffabb2b9891579824d6d3ca55a20c80e5bcbd4991a06fa9f"
    sha256 cellar: :any_skip_relocation, monterey:       "df25333043d24fd03235471252b9a2f57bac5162cabaa9a17646289531400205"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e4423e84879d180cf87def64cd25980e2b5a6b7e5424933e99d312a034db74e"
    sha256 cellar: :any_skip_relocation, catalina:       "32d883f29343f558be8d40680418e53c1ed7e9c6beaef51f6f85cae4d607d092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e57d3bebf016521143ba717a3fa080d59b0ee74a45e152157b5221ef71539633"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
