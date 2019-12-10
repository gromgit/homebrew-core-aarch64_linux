class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.3.4",
    :revision => "434896a7030b7ea030064e6d5f7599022db50f83"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8a87ba1b21488ef77dc80734732e12de934ea42043da67cd40c6d06edca227e" => :catalina
    sha256 "a26eb10464e370259ddd8056e97616ba3d80a1d055cea30f1158a58bcc35bdb2" => :mojave
    sha256 "80eeb389ea7fe64c549e9b6eda0492aff0a49ea5c4da9c15e09358a4869023d2" => :high_sierra
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
