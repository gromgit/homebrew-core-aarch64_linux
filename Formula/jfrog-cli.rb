class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.8.2.tar.gz"
  sha256 "eef227f5d222804894195759c70ef09de1d350467439223c665872aed039cd1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "532c9c88aea26c433ad85b17c03a2f8cb7331d820f5cae4f0f9183b2412d0881"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45584277035857e2b2a751d5da6678d258bd51fa35554062f1f214dd7c934d83"
    sha256 cellar: :any_skip_relocation, monterey:       "e06eb6c21cc6608ad798a2270296f9c8af76c2ab5d09a94d41c6c336cdec6e65"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9153954876d2154e90cbc47cf70c6206d9c81f24de51488dea7e8b5504f42f3"
    sha256 cellar: :any_skip_relocation, catalina:       "41c2f621991ae7d8e8aaf9bcfaeceb455e1889346a5a3f501d179e4ceaf7c2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f884c80d6bf2dc2a9262880e6aeef860929e1a5cdad60234bb43de863030af"
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
