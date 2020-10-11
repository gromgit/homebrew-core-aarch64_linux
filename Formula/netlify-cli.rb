require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.65.3.tgz"
  sha256 "229fec4e6fc9f9b598dceec93a42dfc1623ed90594d7da43a24be0ef3eb64550"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "467bde5aad96b48973f45ae859332b254b802b7f4a63bba9ec2ddcbb36461b83" => :catalina
    sha256 "2b8f9864567c9676ad449ecd5c7ef0407ad2483ad90639a03d0ac9ad7b094960" => :mojave
    sha256 "b9c4f561f4add502d5071251c6a8b6c9bac4de9026861a2eb1202b51c117425a" => :high_sierra
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
