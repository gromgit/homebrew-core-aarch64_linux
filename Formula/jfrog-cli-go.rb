class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.35.3.tar.gz"
  sha256 "5ff83aa5e8a47915da7672eeb29f0660039aeae9da93bf52067a06771a95fa38"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aabaeaf0b4fe520f9f882c78019b514075b1902fe7876423f88fff4bd5d5a9c" => :catalina
    sha256 "be10368fc88581b50cebaba23208f20192afd50ea8a929a6c670ae249125644e" => :mojave
    sha256 "7246e4a5872d9831eccf2acd9f1231debf9aa0be815bdba891f4b2198fdfeffb" => :high_sierra
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
