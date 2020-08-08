class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.0.0",
    revision: "c65e2807499497a507e4bbee183be40bd3c870b2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "896a6d26a9fa1d54ec5c525cc4c3db53fd32099e4e5f4ec79a5654a25dca4f9d" => :catalina
    sha256 "791195439e829f4a7cc0f4df05c983fab6b0a4fb2a25c9a836d5db939ae13c03" => :mojave
    sha256 "dfb08c95936772779312c5c61da43678658981d0c0855dfeeb28f74211b77508" => :high_sierra
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
