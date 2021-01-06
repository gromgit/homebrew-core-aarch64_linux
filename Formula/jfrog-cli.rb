class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.43.2.tar.gz"
  sha256 "cf1f4be33be667044b59762e0e8b02c162946a0eb249bc33041411f117e25e38"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7195ccdef278b1f988dacd555b9d3e2e0a6d0b4e36c82db09490e75ccb80d662" => :big_sur
    sha256 "1cbe797d39f0fffdcf09ef5f49966ffdff46e892b4345b76d06e19a861f2d3a7" => :arm64_big_sur
    sha256 "6c74df8d0a693f735fe6f3309b6c5c85a9ce3a200ea0e4fee91369bceb6875de" => :catalina
    sha256 "d30b57e21ce1571d9e300c6d4b9b9331bc21c50b91f99189073c0413212c8be4" => :mojave
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
