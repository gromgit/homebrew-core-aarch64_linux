class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.54.0.tar.gz"
  sha256 "9ea2ac21c58e53dd221d1502a283857a6b9e2af1076f0778e30774d018043680"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "669242fabd1d458410c0231a6ef14ce0352fbea60dcfed087674aef1da256ea4" => :catalina
    sha256 "8aaaa09a779c06197df718a9cdbd039f5cdbe4e87a79baacdd74d8c5e18d089a" => :mojave
    sha256 "fc5de9f9cc1bcef6b36505e20dd41ebd486b0e52331ed28446fbbc82ddd5782c" => :high_sierra
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
