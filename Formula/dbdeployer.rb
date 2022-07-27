class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.66.0.tar.gz"
  sha256 "fd93ad9fe7636217dcbea52aa38d219da74bd471e5f6f4d22ac8f3ab0cadf860"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d2f0763b851de370dfccb534428f83b0e539a848af4ee470bfd76ee09fcf06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff26b8bd946333ea5d2438aaa3ba90271225da70c575f0cf749ea0b2f711efa4"
    sha256 cellar: :any_skip_relocation, monterey:       "73432001294e8025539d880bf83b1b8591a78bd6c588353b4b00e05d87fff7ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5ba277e6a9a5585ff2407b47df31f2e8c241c28c7cb1bc8e59068b329287657"
    sha256 cellar: :any_skip_relocation, catalina:       "800d44799f85b1c5a256db78cc12f9edf9118276c90a46eb3b30c04719bcd388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f813908fb2133caa58b6b39d644d93355789e90b7c55df2907596a87d33790"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
