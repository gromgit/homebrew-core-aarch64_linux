class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.1.tar.gz"
  sha256 "fc98becb6aa47a84427312caf2d698caef79a1dc258402bb9566594f32196125"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "16edc54a9265f71c9a6eee0505a6f350000782aa23c2274eb8e31633a98282c4" => :catalina
    sha256 "064ac819e6bcfc8de464b494f628de99bdd38e088059ab7edce846b720a2ea0c" => :mojave
    sha256 "6e31c84f69a948a793bc53afdfecc575c9b8e2b8ae33b378f8327c0f611eb4b0" => :high_sierra
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
