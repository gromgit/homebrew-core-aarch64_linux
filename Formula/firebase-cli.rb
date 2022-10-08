require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.14.0.tgz"
  sha256 "f5d19f543b654eccf704d1e3d3917930b2f9143bf2a16bc2f9bf6bf94d8d4947"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "bde6c283fdae8b98cd1bad64a427df3ebad2b028455990a941c2180d65e5b7bf"
    sha256                               arm64_big_sur:  "402f5e184518c4c70a28671dd9e08926ccd0b31fd5fbb196041ad8e8c66a5996"
    sha256 cellar: :any_skip_relocation, monterey:       "dc8e989b2fc5f0450e3bc4656755956f3adbd3e5e7e5b404d9de59639e9e22b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc8e989b2fc5f0450e3bc4656755956f3adbd3e5e7e5b404d9de59639e9e22b0"
    sha256 cellar: :any_skip_relocation, catalina:       "dc8e989b2fc5f0450e3bc4656755956f3adbd3e5e7e5b404d9de59639e9e22b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea106d77675297871eab1c0e05e976aeffffb22dd9f911ff3f98d8e94a37001e"
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
