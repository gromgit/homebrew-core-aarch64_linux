require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.11.2.tgz"
  sha256 "4c7bf506c78b73cdc2036f4dd774b362c929a0382fb3524738ed0b6eec41bd0a"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6dfd8ed4868603cc7696d3d8afc2334acfb7f0d43c227d6f0edb0ed7e5b21574" => :catalina
    sha256 "1dd082bc84f83547e94947e575ccda011c6e78e17a6f1dc1ed5cb00a068078c6" => :mojave
    sha256 "68a1c1ab47b0b839aa43fae10fd94b949447631a21df8e46fa4313fdd4090535" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
