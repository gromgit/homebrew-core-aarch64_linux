require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.63.2.tgz"
  sha256 "dbe73fd2b4ef88cf68bfc97fb5aaa2a67ee70a93efe1b7d09ec7be87fe2a3eb4"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "599e2dd1f082a6494163f9dfa2625569542b31a172c0a37af20f9f9a59a69d3e" => :catalina
    sha256 "b8e77e1ab687f7fa2276178f892ff7d34062a5ce779ab7ade1b75dac95014078" => :mojave
    sha256 "3ad8b745f5a89a181e1826fb881c1c8ccf3d5be3ff27d12f38fd431ddca58c9a" => :high_sierra
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
