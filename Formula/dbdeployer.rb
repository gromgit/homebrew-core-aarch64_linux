class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.58.0.tar.gz"
  sha256 "a73473db5fe8a8ef0fe6f2d791ecad3dfd7f1f331ab0ddffe20ff20187892093"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc872b9096b1b93ff20408c90adf9c52f14460b2f25aaf55fb601fee7e31f36a" => :big_sur
    sha256 "2662fbc7ff443f1941dfc13f72f336100d2d866637fdf6d366dff854e17de4f4" => :catalina
    sha256 "8706acc54a4278288eb16cb84c111b40a4380b366a9deb118c81de5387d73dd6" => :mojave
  end

  depends_on "go" => :build

  def install
    system "./scripts/build.sh", "OSX"
    bin.install "dbdeployer-#{version}.osx" => "dbdeployer"
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
