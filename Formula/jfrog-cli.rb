class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.41.0.tar.gz"
  sha256 "f93ed8222b82e1a3faf2cfd953d3010d5bbe9287a2981bcf21c40494f9373b72"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5236895e8e7c575fba41c5d6b0a85c93450d4aafe5cbf4d50bf4f0cd669a5b24" => :catalina
    sha256 "291aca3df6339557a242d249b8e6db4f4def33710f13f1ec377f507f6591a6e2" => :mojave
    sha256 "2bfe533a50c3233a46dd0134a258ed8df7c82342ee13182eea8eef8312010604" => :high_sierra
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
