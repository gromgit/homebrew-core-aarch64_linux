require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.14.0.tgz"
  sha256 "708153ee852bf6327b1935795173e54dce1855fa20fcfc7b9437c4f570072ce4"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d6ad800b3d180d1b7cee3eb91257dbc105fe5e7cd100030c4bdc2206ca9e4d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "88fba62d3f5c7cb539ffb3311d8edf5f7b8baa948b78ccead671f25ccd347db8"
    sha256 cellar: :any_skip_relocation, catalina:      "29ea59e50b1083a639c4bab073d4ee51514ce0dbd9088763704a22466883f7cc"
    sha256 cellar: :any_skip_relocation, mojave:        "6fa7b71eee15e4f0f3d0bb67d7fc18c96422fabfb99d98e73c5e108ceab6ab05"
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
