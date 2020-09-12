class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.0.3",
    revision: "f2ef0c9191efdf98a9edb11c0d8c6309ad5f8d49"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7e34605b33a5b4207ca8757878ed6e49ea76c513995348b52f9b923482660163" => :catalina
    sha256 "d10b4661b145afecce14f386d102518610146c35f2cf631301948d72f87cdc78" => :mojave
    sha256 "c95ac98533d5005970701e3a3f605565745800bfee61097fa6a0927a5e5a8b6e" => :high_sierra
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
