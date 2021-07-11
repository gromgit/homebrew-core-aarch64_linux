require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.1.20.tgz"
  sha256 "f4b05830001976be95b5e50def111bd5366f6555aade2260bcb784ae9775598e"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e652bac3615c3e4b2640167f5db4d59c7d397275163caa6c527f25de55c02fc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "98b3d8043cc842a28e494e6ca9583fa39f1da98491260cbe3c145f635e1efb19"
    sha256 cellar: :any_skip_relocation, catalina:      "98b3d8043cc842a28e494e6ca9583fa39f1da98491260cbe3c145f635e1efb19"
    sha256 cellar: :any_skip_relocation, mojave:        "98b3d8043cc842a28e494e6ca9583fa39f1da98491260cbe3c145f635e1efb19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91acad49f225ea2c5abd1f267a081bd1e2863ac6f5f2a8a1f1a46413567cbee"
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
