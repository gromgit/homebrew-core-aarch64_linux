class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.3.tar.gz"
  sha256 "55dc402fbdd9471060bd4cf38ae27584cf83084aefc978d9489c15f7dbd5b910"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a99251a9fec14bc923c5d6277e911de1caad88a0a45baae938cb13989f7da21e" => :catalina
    sha256 "9ebc01c9a3cbec60704c1513fc81edab779f96b8d68735c94910dab94458df41" => :mojave
    sha256 "e90da42fb15bf8b956a373f1907b602edf4ec650ea7474d03cc7eaaac21a1b5c" => :high_sierra
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
