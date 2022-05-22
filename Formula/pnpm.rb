class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.3.tgz"
  sha256 "e90f3cf617745b82245ff7938c36f2f852dce4715da084a95561dfb03087b529"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "634149ca75827a7cf3fa0c477bd140c8b7b5bb893c1158a83ef3c5f282c46c65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "634149ca75827a7cf3fa0c477bd140c8b7b5bb893c1158a83ef3c5f282c46c65"
    sha256 cellar: :any_skip_relocation, monterey:       "64a69bddb3f93f6b7655c7ab70ff40b28b4206aee33d2ec8f5ac0504b19b7aae"
    sha256 cellar: :any_skip_relocation, big_sur:        "6612d7246d25d603c16469a066dab41f4e3267b5249eaf3c6eeff2bb8e382c01"
    sha256 cellar: :any_skip_relocation, catalina:       "6612d7246d25d603c16469a066dab41f4e3267b5249eaf3c6eeff2bb8e382c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634149ca75827a7cf3fa0c477bd140c8b7b5bb893c1158a83ef3c5f282c46c65"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
