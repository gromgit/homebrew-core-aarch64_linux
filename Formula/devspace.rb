class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.8.4",
      revision: "a5cf9b686ab1b9bf295d8e9316130fbccff82220"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e20c1b97099aa696d66e0c520b22daba8383d14d55ebcd1ae4b65a82c54c62f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3370fe849ddaa8e51305586966317f003c510f68a6e6b5939c2f5d1ddd3d0a8"
    sha256 cellar: :any_skip_relocation, catalina:      "1d1e43324219582605aaac321abc63c97e7422949a95eb233de7c56c1214ad1d"
    sha256 cellar: :any_skip_relocation, mojave:        "206be63e9e43564885f24f43534f6ad0f42c98fab64edb729924663fbd18dff0"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
