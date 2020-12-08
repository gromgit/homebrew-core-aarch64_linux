class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.5.0",
    revision: "5ad9f825c09c8a67c13a08e2e61dbe03d8f091e7"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/devspace-cloud/devspace/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "651e0db30986753192da303b816bd259740ce8a5146711698c50a74921ab0f00" => :big_sur
    sha256 "6de4717cc24d8b38b38a6ccbcf2bbed17df5cbb556b1e1eb14280f6e0bfe3db2" => :catalina
    sha256 "a08b01a741a1c5f51e60ee3489738ffc0389d8822e7ead361dae4b86f5597c25" => :mojave
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-ldflags",
    "-s -w -X main.commitHash=#{stable.specs[:revision]} -X main.version=#{stable.specs[:tag]}", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
