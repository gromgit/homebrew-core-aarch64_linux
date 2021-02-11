class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.7.6",
      revision: "0a3ca2d18dc632a707aa9f37980f96ae714e131e"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "baa0ed79f0171c3b251e5de6b38ca13b63cdd5a68cf472ec4070d5109084f4cb"
    sha256 cellar: :any_skip_relocation, catalina: "d21f74b5db062fdb1a5dcbcb52640e7d4ae80f9c2e7c6e4e1935e7cdb94e811e"
    sha256 cellar: :any_skip_relocation, mojave:   "c1d4d713504f7e46c13b7f68d3d4cbe905a40e58b2ef00bb36c0f416941cd8a8"
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
