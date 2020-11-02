class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.40.1.tar.gz"
  sha256 "c956b8750f8df440a70617e4dc1109d6f17e19a51bb60a64fc4681b83c8aad48"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "429a4369a845793bc28ec3665f7214243b87bb3b516f705cd2a8cf87ab8721ef" => :catalina
    sha256 "0f20b63cb07e5119000becb106143ada57338445ff07a02b702b735f0bf23419" => :mojave
    sha256 "49efaa10249842d061a6ade4763995fe3255385cb990de80ef7a37a8eaf323c6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
