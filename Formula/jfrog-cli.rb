class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.1.tar.gz"
  sha256 "fc98becb6aa47a84427312caf2d698caef79a1dc258402bb9566594f32196125"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c49be5088928183d35ca307d5fcabebcf77cd5c987f797a95e01bf7c98c8c72" => :catalina
    sha256 "483b549ad558235460f70b88772f08b6e53475058e8800e848e134f79d242e2b" => :mojave
    sha256 "5a687fa8deec51220cd6609fafa85f6be6891bb53bb69a1b40c052731d381089" => :high_sierra
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
