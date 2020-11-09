class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.11.1.tgz"
  sha256 "daa764facff1d1e5bfc420f2c98b135a8afa6beb35699753c6d8b85970c6f9d0"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "25c781de3c7262fc1f9ebadadd727282f8f8d36dd240c961e9952282ef26f8de" => :catalina
    sha256 "56b2a3b5e336a2224fec58097b5b156993050b07953e4ecf84c7b51815333247" => :mojave
    sha256 "531a8ad15d4a5478185297e22a21592ae622fc7a71c7ef39a2dbbc8ff4e589c0" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
