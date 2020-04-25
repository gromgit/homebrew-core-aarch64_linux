require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.48.0.tgz"
  sha256 "3fcc90051023aa9b322901c4fb0099f521df8ef9502b8659bdd29f76116952a6"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81307af28a5c165b6cf5177f417d5942429247a8fe0e431b29a94599f131fe3c" => :catalina
    sha256 "895688ad9cc327662c6c78d9c8a95e376130c553defc9a9ecb2fdae6e7220c55" => :mojave
    sha256 "a32d2bbb24090088640134c7e7f6ac1df23e77feab1b488441b09979174b4702" => :high_sierra
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
