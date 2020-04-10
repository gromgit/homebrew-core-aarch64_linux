require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.43.0.tgz"
  sha256 "696a2a2ba38e64d1d5d33501e16a6f62982c8e4b7f06a8db8b7dbd76817292e9"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f7d8f4fe3a89751bd8d6decf69dcd182c42f15ca3815523d49b44f9c4436812" => :catalina
    sha256 "dc721060324e301a39dfd97e7bd83d289a01647729779d8d884eff94bedb2a99" => :mojave
    sha256 "1da7cf1fa5c67d330dbe2f8451db51d7e7b1a691c4bee864c5746c257900bf65" => :high_sierra
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
