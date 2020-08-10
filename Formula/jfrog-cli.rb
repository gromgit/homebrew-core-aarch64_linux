class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.38.4.tar.gz"
  sha256 "1b321e186c3a745fce039deb8cbd9ea38e27b9f01972cf3a153b601597c60854"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "79ad4f04c8b6aa2ec4df1fcd04cec156a4552448c8333a21c642fe980f9c18b9" => :catalina
    sha256 "9ced3f5817f41ec7e8422bed551c5f54d9d5ceb7ae61ec5cff2b7d7f63f5d8d5" => :mojave
    sha256 "901c1b385c7f639e87e92cfcd8d7e08075caae808f165e25cdf951d1c6f98fb3" => :high_sierra
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
