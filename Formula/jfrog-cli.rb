class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.6.0.tar.gz"
  sha256 "3423284d2c9e23e007814e427a2fadf17cacc2c05cdd2f8298a621ef72264572"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8780499fabbd43156ffd4b212fd70ea010eb03ed46eaa2c9499e6010417fb110"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aac078d34f7f6e5e74dc9a6bd1b5d904fbfa2f04a62335057d1ca547d337e248"
    sha256 cellar: :any_skip_relocation, monterey:       "54a7e3fac131729ceefaa523b90ca89bff57e80a2f3b5e8443df46119d34fcf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "698e53c0e8c889baf4f27f6def604975828059bb37c222bd4ce42f2976c270b3"
    sha256 cellar: :any_skip_relocation, catalina:       "821de6516184c536bdcb2899f194812e787e78f8baaed5849f42c8040b2256bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8dcc78c6c437c21499ba1f4ca6451d576745cde2335cf9154199edbdeed2792"
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
