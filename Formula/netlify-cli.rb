require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.64.1.tgz"
  sha256 "21ca98023563a59a3a8df601ba3a63215498edd45059d5db6cbcbddd7eada252"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4381838fe187ef8244b6be889e92eef44a2640d1976ff4938599592ea13e2973" => :catalina
    sha256 "de3b7ebb21c564fb89e82eac37618cd23723dc3553fa133cde92b6c1346032f7" => :mojave
    sha256 "7b8ae3800b249fb4bba3b57c84751a9ab8a579f7a7f187b70e692786a170eefd" => :high_sierra
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
