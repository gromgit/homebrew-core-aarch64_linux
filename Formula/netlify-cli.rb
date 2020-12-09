require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.4.tgz"
  sha256 "c048f4c96aa7bf875dc04a06754fee01e23e6972a6f27ced4767c734f03542d8"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7c4447f231bcb19b7b5cf2af06fe7d2f2e8d206e9b44d6315ed91b3cf51d0b14" => :big_sur
    sha256 "cc16aea3320d9a29764def4fd0a4621c06799e47353378d8a58bb01f40d0edb5" => :catalina
    sha256 "8853d068144f60a5edbb7fd64de6da642a52dd319f4465e22580c23f9877ea09" => :mojave
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
