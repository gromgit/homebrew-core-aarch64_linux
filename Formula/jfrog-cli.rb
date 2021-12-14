class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.9.0.tar.gz"
  sha256 "91f5c22b94de0de1bea3d141b54d3173e422e75da5088556f8ce0c4f2c6fed76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b93ae1a704c4af453be7ec0952b5d8160c2b1229a370394e0eda5c34aca9b008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cf8327e8900ef9bf700200b438c6876067e03eaacdbec9fd9f37aa90a6fd7aa"
    sha256 cellar: :any_skip_relocation, monterey:       "8ad3e9e9219eae4c94539297403be91732e772cfcb3aa7a8dfbfae3b83f7bc28"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ba85e9e2a806b7a383b58bcd44cedb5d60530442c43ecf6f3782559859f5468"
    sha256 cellar: :any_skip_relocation, catalina:       "1bded2ea0294867c04c88b03e8042b446dabbadbe292cb5f3f0b5ec928f2137c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0222cd758860837a0668ee3764b4db5444c9f6524da5e83634e58131b3b5b858"
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
