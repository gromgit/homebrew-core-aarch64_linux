class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.34.tar.gz"
  sha256 "d3062e1e69406df4649fad64968c7f185bf430a210e5863b159554e076dd0c13"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed7e6bb64dc6ae191629dd0926c551f4711c20279353106b6ab910597fdae5c0" => :catalina
    sha256 "dc63cd551ca4dba836795dec1f2c38301f877db843d30354328fbf88ecfc89d4" => :mojave
    sha256 "764b7fdf043b64037522b90afda7bf56bc3d609bb4e3d2f66fc35c41bf308479" => :high_sierra
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
