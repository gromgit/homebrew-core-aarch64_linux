class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.2.10.tar.gz"
  sha256 "67d04ad5a29522f36b5545bcbc9f6199be5154dc6c752185f903b096baffb87b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81e4b43f8bf6857f24937b6604ab6e03e458f45159298017af5bbfa6b3f211b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb74c5026cec1abe8c0a053b44f0b219903ca09506c512b2ccfbca001dba013d"
    sha256 cellar: :any_skip_relocation, monterey:       "6b382d3241472d64a9692e02cdfedab7946061d0712a580785d12cbaf5a2fcc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b383ef1e46b5704edc31e74bcad04bdd4e46de05f52d30e3f21e44ba4620bc3"
    sha256 cellar: :any_skip_relocation, catalina:       "b5b618df26bda0354886f1ed7525e60a605fb8563af1dd54eb5b5ba1de8324a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c39ecefbd27e0e16fb79b38dc095187d788b5a4964f2d350b2bab9aacb110170"
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
