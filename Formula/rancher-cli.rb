class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.7.tar.gz"
  sha256 "f3ed3cc276d2dd5ee672391125d3b4d6a3be9337e38ac59748e32c99b4d2f725"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git"

  livecheck do
    url "https://github.com/rancher/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9dcae93136d9f79a102ab1d7acd3da9d7ea51302150dfb63aecbc39a8232825e" => :catalina
    sha256 "cea838a7d939f24f60f98df61d58206385f944269bfebefac16cc046cf0537e2" => :mojave
    sha256 "c44ed170e389fe323966e95d25eff6adefdf3e44f3dff3656ec8e5511155bf2c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags",
           "-w -X main.VERSION=#{version}",
           "-trimpath", "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
