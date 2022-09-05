class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.11.0.tgz"
  sha256 "4806143590b74b52b5cca2e8851f1aefc7e8a66b6d06188920a1b3321653b913"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b0ebdb897297f8f095019435f4feea22e5c63bc5b0fba4e2342ab93f5a8294c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b0ebdb897297f8f095019435f4feea22e5c63bc5b0fba4e2342ab93f5a8294c"
    sha256 cellar: :any_skip_relocation, monterey:       "6b1bec9e72240ac4810b93fb392cabf469916449d2f4f387b012d5a24aed6b69"
    sha256 cellar: :any_skip_relocation, big_sur:        "301869d5b442eb120ba334bfa6a5e769bcc27fd80ea4f12a04ed044e4c362c43"
    sha256 cellar: :any_skip_relocation, catalina:       "301869d5b442eb120ba334bfa6a5e769bcc27fd80ea4f12a04ed044e4c362c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0ebdb897297f8f095019435f4feea22e5c63bc5b0fba4e2342ab93f5a8294c"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
