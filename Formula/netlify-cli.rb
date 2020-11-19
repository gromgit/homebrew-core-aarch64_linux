require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.7.tgz"
  sha256 "d87415b85d267d6100c67cb5cb026df418ca046024d7200faf7c6582e7e60678"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cdf8956d9807709bbdb6e40f3664f459ba70bd15351a1e3225f264c222b7d814" => :big_sur
    sha256 "d86d33820b3a95fc1b99cca6ed6d22daa73302c9cfa8b3a368adaaea8c6d6436" => :catalina
    sha256 "b0dd3abf0c1fab0d5eed969b12f9952080978576bc99cee55b8f14da26c98139" => :mojave
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
