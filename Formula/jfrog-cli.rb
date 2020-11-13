class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.41.1.tar.gz"
  sha256 "6da7aeb5ce3e28f17ae4a1d5f91cf48a44ef1b8373c5eaa2ee7bf45cd7968532"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3d8780cc32a80388bb51a35ae2c01238ba33db7ae275cc1ad104b5514554973" => :catalina
    sha256 "2dd25783c525b6c18228d8cc9d8fd1898e2b6d76fb1ee3d6259ab070d5939c16" => :mojave
    sha256 "c331c0ba7d1a5f17043a51c14a89b422edefd18191b1f7deb36d2a212efad698" => :high_sierra
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
