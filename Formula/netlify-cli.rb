require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.16.tgz"
  sha256 "2c98d5a7a8a8b5647efdccf7877b468d3ad6d1b150fb5c91162876c7ddc22f67"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b14962c3c3cf3ae966a5450f9d36eb17be95f6c6eecc759f9b431b6079ee4b84"
    sha256 cellar: :any_skip_relocation, big_sur:       "30c6e4b12882290c8d0c269b0d68cfb6730e554bb7650b0da202b4e5fcb87fca"
    sha256 cellar: :any_skip_relocation, catalina:      "30c6e4b12882290c8d0c269b0d68cfb6730e554bb7650b0da202b4e5fcb87fca"
    sha256 cellar: :any_skip_relocation, mojave:        "30c6e4b12882290c8d0c269b0d68cfb6730e554bb7650b0da202b4e5fcb87fca"
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
