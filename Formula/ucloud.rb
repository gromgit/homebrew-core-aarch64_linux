class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.31.tar.gz"
  sha256 "c6401378c14a6d6101323220f8ff4ba273230ace4bae8d5e061a6be4a58a2130"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9ffadc6bcc6dec3a0cd27b342bd79ca89e9107ccf0bbadbe1c9e2962b083053" => :catalina
    sha256 "d2f80e0f5b08496f9bc56dc18ab845fc563c796f32ff450a4a732a9ac850ab12" => :mojave
    sha256 "12256c2e6ff2e0006839f6034bf7c69113d10fd4f8bc455b3b647468f343b9c6" => :high_sierra
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
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
