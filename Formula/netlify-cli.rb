require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.10.2.tgz"
  sha256 "c7a716c5ed6438e6d999a1d3c58727303b727e5267a5588f35862232e1af554b"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c31b5c7dc58c95f7028d84bfbae5f24ef1a83156cdcf653beba896dee82f5a22"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5e5d3c21a80b555c8f0f11fd04e28344205ea3c4da477192eaaa63ba7e45922"
    sha256 cellar: :any_skip_relocation, catalina:      "1ba639c8ce439f59d873fa147017acbed8c42a4370caa723ad1efccd624e19b0"
    sha256 cellar: :any_skip_relocation, mojave:        "26728bce40353d39f798389cf67e52aa3f41dfa3af4c53c76dee145fdacdfcd0"
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
