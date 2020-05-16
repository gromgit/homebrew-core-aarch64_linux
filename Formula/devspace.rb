class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.12.3",
    :revision => "0b253245a7c9d9cc7a04aaf9a0ddc69ca9563756"

  bottle do
    cellar :any_skip_relocation
    sha256 "2379caf22ba205ad461dfa4ec17578c6f16d848416388df536e3252ec00d5658" => :catalina
    sha256 "9dff72d9b3b9de32f9bde52375f592ed77ed880765ac3a642eb454f460534e16" => :mojave
    sha256 "8fdb0ee62278075246a6ca16ef8aa070a0066006cd6caab2b411baaa3e30612c" => :high_sierra
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
