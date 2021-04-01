require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.4.1.tgz"
  sha256 "8fd8d2f880025da726adfdff427805c55a43c06e86121223818a1485e1d02a4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aacdc763fcbe5c7279fdbadff41424722b18ad64c41bd9f478f0b660e9aa9f4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "5fd66895cf0e4cbc5bc53904c7cad3e8ab85498f1834b6065ab1bf07c8551ea4"
    sha256 cellar: :any_skip_relocation, catalina:      "bcc8bd3dbb63bf1b50a13f450870149914de04298968c823ee93b5bd291c68ec"
    sha256 cellar: :any_skip_relocation, mojave:        "ecff0744062e64d29a44fa13904abf32cda16688c19e8ca39ea542b21e1c2b61"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~EOS
      {
        "name": "grunt-homebrew-test",
        "version": "1.0.0",
        "devDependencies": {
          "grunt": ">=0.4.0"
        }
      }
    EOS

    (testpath/"Gruntfile.js").write <<~EOS
      module.exports = function(grunt) {
        grunt.registerTask("default", "Write output to file.", function() {
          grunt.file.write("output.txt", "Success!");
        })
      };
    EOS

    system "npm", "install", *Language::Node.local_npm_install_args
    system bin/"grunt"
    assert_predicate testpath/"output.txt", :exist?, "output.txt was not generated"
  end
end
