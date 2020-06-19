class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.13.0",
    :revision => "c29f25a287002e41d2208301763268089551ec95"

  bottle do
    cellar :any_skip_relocation
    sha256 "800c4beb26a89994591ac2b93d34df71c216a4119050b14624484309fce91d3d" => :catalina
    sha256 "fddccd393244d8caecd811418a97f33656386695a1ea887e8ae5c739ab3c087e" => :mojave
    sha256 "1d7462c7832f9935b7440ac252cc814713a43d1f27cbcf5d6c50f69502b6445d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-trimpath", "-o", bin/"devspace"
    prefix.install_metafiles
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
