class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.7.3",
      revision: "99eb86780cf63102573e6b6caf17777d41c2e008"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9e9dec3681659f0477c563488e549442f78214ba042b80257a8219fc70e3dbd4" => :big_sur
    sha256 "decc09c5069587116e69e28b71bccdbf66a81343797485eaea799784211711b3" => :catalina
    sha256 "269e62eba073c14ca1951f2ae923ef79b68eab77c9eeeed98b07a2a6e587b3ce" => :mojave
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
