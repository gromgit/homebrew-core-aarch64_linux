class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.8.0.tar.gz"
  sha256 "ec17389afe4b049ef78002b6a7826a398d43aa6198bbebf59c9a075963992f43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41fc29bbaae54fa459d8344e87ba0486625292259d0f437137d6516d57d007bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba5beacd9b1933c3468e889bc281b2082c42b810797f509029042ecb32282f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "593674b1d8fc84eaff30d9f472154fd012af920ef06a70c74e7037d6bb269e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "d15af2bb08bb39f676bcc69aa9fe00fd44ae649b32a3c565bf07bf32bba52b16"
    sha256 cellar: :any_skip_relocation, catalina:       "984e338369a6ab675b414b1fd83203328aa0eb4eb578c4abb4b865cb1430fd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f680f4ff7ad098bcb3b88c20181881c79c28d21268fd692f2c52f65b801e2f"
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
