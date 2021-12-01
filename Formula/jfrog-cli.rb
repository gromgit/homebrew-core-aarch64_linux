class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.8.0.tar.gz"
  sha256 "ec17389afe4b049ef78002b6a7826a398d43aa6198bbebf59c9a075963992f43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e96d3c3887ebd632d5dda63c54179b6f87059cf74119da509c459819162193f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0d4aa2e4a6a78633e573c1df75511fa62c685e48c0f0e29cca33abc0d18ff3a"
    sha256 cellar: :any_skip_relocation, monterey:       "16599829b68cc1f8979a8b7c02f1dffb0d12d7e31e066633eb86a2c06fec3e03"
    sha256 cellar: :any_skip_relocation, big_sur:        "f94b191347e15b76df3b3d0fb221c352981d4e311f542e83caac05810617ccdb"
    sha256 cellar: :any_skip_relocation, catalina:       "cee1ccebe2b8ecd6cb7fce7bad00aef98cea54af703c671425acf2220b28d53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fe2fb78f9f2187222438985cf7dc055b8005117e4513eff503ec6f01d615eca"
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
