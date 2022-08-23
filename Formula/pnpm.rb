class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.9.4.tgz"
  sha256 "0b32f738092fd9dcf8ed2eb60400577a83adabccafec68618fb1164636d6114c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919b4707c7810358cfc905aa5191325b66912389ec472cf126014496d4b5bd51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "919b4707c7810358cfc905aa5191325b66912389ec472cf126014496d4b5bd51"
    sha256 cellar: :any_skip_relocation, monterey:       "a8bc6f61d9f56f6aa415145d3dcd59243b555cb32ab1d867cbf354b1f2a5807b"
    sha256 cellar: :any_skip_relocation, big_sur:        "825c210548ddd6fa1a721a4759c772ccdd66b6076cc9ffbf822b257f1f36eb3f"
    sha256 cellar: :any_skip_relocation, catalina:       "825c210548ddd6fa1a721a4759c772ccdd66b6076cc9ffbf822b257f1f36eb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "919b4707c7810358cfc905aa5191325b66912389ec472cf126014496d4b5bd51"
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
