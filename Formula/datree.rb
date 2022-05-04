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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7b927db7eefd9440b8c0075eddb045164fb03a457255ce5d2057d7f01cfe4b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68dd34c8d5f78f8324edee865c11d437ae1824e79d3aeeb345dd9e57a91bb5e0"
    sha256 cellar: :any_skip_relocation, monterey:       "f94a00b5b46ec22c26e9e06d1b9edbb0449bc85af48b81938a17ccc757ab3a2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "68206e4519ff5fd8530bac2eaf6f87420ed7aaeb45729629b91d4320012821e2"
    sha256 cellar: :any_skip_relocation, catalina:       "05df8ddeae8bfe0286602d30cb5bb727ba9acca51441d058b342f40f65891f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5077a9da7a294a49c5eb965feacb509404aebf6c738da1ca207b9aad827c18"
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

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
