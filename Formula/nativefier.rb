require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-43.0.2.tgz"
  sha256 "631bbc87ada48db0c225d9f81f6c81921865d686175d8fb40f47bf1c39e95b0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11ff0d048015f27901ba0a3e18c225652b988d3aed75d6d3dec1bd20cf68b18c"
    sha256 cellar: :any_skip_relocation, big_sur:       "babbea6809c58629630be76c15fff61864bbdd1e51e3ab054276372e5a0930a0"
    sha256 cellar: :any_skip_relocation, catalina:      "1c0034635b3b9c883c6ba7dcda5b5125636688cb0fe5f6a7d081dfcfcc8644eb"
    sha256 cellar: :any_skip_relocation, mojave:        "cb6eed10054a611beca9e70817feee8a41c652d40a557084544d34bed8b1f295"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
