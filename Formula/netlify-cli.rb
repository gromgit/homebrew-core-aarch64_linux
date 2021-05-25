require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.30.7.tgz"
  sha256 "439ad6abd1839a41d049e99cf95e5e26772067a7190efe4539f83b4798c1cf0e"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2d9a5c7177a45b50b24a751c232362c8bd46b7e277b0dffad4102129ec2ef4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "109332635e23de9d957149ccb43a95123a2ffa8b29d14107768608ab460be07e"
    sha256 cellar: :any_skip_relocation, catalina:      "109332635e23de9d957149ccb43a95123a2ffa8b29d14107768608ab460be07e"
    sha256 cellar: :any_skip_relocation, mojave:        "109332635e23de9d957149ccb43a95123a2ffa8b29d14107768608ab460be07e"
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
