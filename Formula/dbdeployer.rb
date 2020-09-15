class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.54.0.tar.gz"
  sha256 "9ea2ac21c58e53dd221d1502a283857a6b9e2af1076f0778e30774d018043680"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0489472d72bf88f37bd0dc2279a09f86b4fbfd89d5ddee42c05a0e02160c4b8" => :catalina
    sha256 "9d5d8201b799d39cd843fac979ca09c8b92f1d02ab38fa122bcfcc51bb36a397" => :mojave
    sha256 "fded473cd07007386d719e2826cdd876838908a10563b0d3987edbdc181ab97c" => :high_sierra
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
