class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.10.0.tar.gz"
  sha256 "820d96ffc3073ec34906745df52caff5809edb7b8a6443956c651bf94c8d7880"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80ace3e765f73df18e7135369fdaa487a1e14e828c442d4b3ecb28daae780dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9959df6044e111e9c3c93f76d4d0447c660c949f303de0c87c96d6d50a22a70a"
    sha256 cellar: :any_skip_relocation, monterey:       "2867d0b99ffba4bb0a92c5f432332f969c866d6b02cd466cd89883b068e1521e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d425bf22c7e83957b5eb488d0841f1614b2f8212ef3a74a7feecfe5093fe5dc4"
    sha256 cellar: :any_skip_relocation, catalina:       "4d206423d67bca0fa8294928fd805ac8ac691384122311a6ce57dd0ecdecbe80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4d03f751a2344c11af2948c695b614656646695dd1f88881029d5473731798"
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
