class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.0.2",
    revision: "703926cee72799ca29226adacfb78daf7fc75a56"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e72642299adade2e978439f2e7085e260f8d00c4146cd827545bb30523fef307" => :catalina
    sha256 "7996fb5ac5b4bc17e947cd01d31faabc24263a372ed285e52ffc8d750fd0997b" => :mojave
    sha256 "b38b75f6cd8e8045cbbcacc781cef2f21920c018406c3852aa9c428db3a1254e" => :high_sierra
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
