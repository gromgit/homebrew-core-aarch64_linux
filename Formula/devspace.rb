class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v4.14.0",
    revision: "c62fc7e1531aadafaecd418cd6f2c260934244e6"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "09545e263d88a5cce5129d58b7cecc2b4f609266bb2f7280c911bb6320304e6e" => :catalina
    sha256 "85629be8d03222a334b32ddd61dc9b599bd86a8644295faf4ea050020568eeba" => :mojave
    sha256 "2a8e26bec72882dd303856c7960b664f558967382e82a2285cc871075f9639a3" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
