class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.6.0.tar.gz"
  sha256 "3423284d2c9e23e007814e427a2fadf17cacc2c05cdd2f8298a621ef72264572"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71bd9df66789ea1e7b582ccbb7fbece7b1166027dbb635e414ae851565dfb4ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55db22329c03e709bfd3f25af8c7312dfeac96d30e8896545fad844bbc0ee75b"
    sha256 cellar: :any_skip_relocation, monterey:       "74ec8288a964571340f88f7ca95ff43e3543d39f5647e786d3852ab15206d9e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a0e7aef19d27879e26c35b899cc9a41a57ee55a12108cf7b22c8f6b0bc831d"
    sha256 cellar: :any_skip_relocation, catalina:       "0c8ca16d804db0a54464342ab2d1ee42fee54812d396f40950837de2bab7e2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93a681a0b6c154fbc0a12618a3ae10860ae07aeaeb37b2d88676deb75ebddf1b"
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
