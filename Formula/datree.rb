class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.3.5.tar.gz"
  sha256 "f871dee8b3f3ab2d6d69104030ef1e9e2c10d8c8be7d3cfa57607fcfb2959046"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d84d5ec3101c0d0b759efa76e02d82ebc587fca4c24e3a4192f02c5c178ef6c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edbfb4da0bbf3cf776ea33767aed62bbc2d61dc1a5f53a2ceaa57720993860b0"
    sha256 cellar: :any_skip_relocation, monterey:       "b27f82de117456ff5c48f9e2bb0bcc491e9a9507c7448a0b2259f973c5018050"
    sha256 cellar: :any_skip_relocation, big_sur:        "c26592673664c3e4aa493a44ff7bf422061be6797c086284e6546d547a6a624f"
    sha256 cellar: :any_skip_relocation, catalina:       "e6264abbac17e672206bf303a419aa17523409a87deb8b2b002a1c1e9466b2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b49b3f9dc852976f75b671aaaeb4f51b773d18e6f400131a6c51268e8db3ea5d"
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
