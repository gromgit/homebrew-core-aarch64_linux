class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.5.tar.gz"
  sha256 "394768da33298ccab33512080fab93c022957af1b32f796fb7774f643dfb5fdb"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b6621fca0e98a55ddc7cabe60e23f96f6403fc74e5eb2a2251da34628a2a0a93" => :catalina
    sha256 "3c45607a783dff338828008a11460812f40782f25d9b7e30c3fe259279b10df8" => :mojave
    sha256 "b3ad252a016e1103e036113390631efc878362739f7ebee795de478d76a5736c" => :high_sierra
  end

  depends_on "go" => :build

  patch :p1 do
    url "https://github.com/lxc/lxd/commit/4a25da23b978d2eacb145d710a9682cc12b74f88.diff?full_index=1"
    sha256 "d3bd63cd2344e4ad2fc343cf85e8db0d80313f424eec0864a2d06786102b63ac"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
