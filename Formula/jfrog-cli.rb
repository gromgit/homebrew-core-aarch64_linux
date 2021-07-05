class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.0.1.tar.gz"
  sha256 "213c2ce64d3616c0bf10d4d4fb9287b3ca09c4a2a4af3c992c7089ebef599022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39b6e778e6ea33a8dbed2ff00895a1bf69e0e8f259de5eb5d9d7c3215fdc1224"
    sha256 cellar: :any_skip_relocation, big_sur:       "92733d9f9d316d2e26886a412ebce9d3e3f246548c995ea57a1e62133243859a"
    sha256 cellar: :any_skip_relocation, catalina:      "f739755f72347e168646ea40c4c75fcb53d109c4d86b5d03e1298a2442274268"
    sha256 cellar: :any_skip_relocation, mojave:        "96d7a133ff10d49e6f63819e94f282e43e29ec4d5c66e651aa773064226159b0"
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
