require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.71.0.tgz"
  sha256 "baae2ac7da9da061d279e6fcb4353238cc560eb7f91fc5bba9451822e0c583c9"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "72169fd22986ca833913237354f533a9f2b6a68960482361e314d78d7b458f7d" => :big_sur
    sha256 "884c723d22ee0895136ba74a2eb42da6bc54c030919e90358f67023fbde771f0" => :arm64_big_sur
    sha256 "929cd2a1534e22a8b706522850a465fe87ddbd89a14cf700c8dd67f830f3084a" => :catalina
    sha256 "fe64b5f50f942dbd6ee01b12521011c32cc2fe4a118ff9090935ea367633bf42" => :mojave
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
