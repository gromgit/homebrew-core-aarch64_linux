require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.2.2.tgz"
  sha256 "2bddffdbc744f75f6b57e0f7225bc5a945b228b627b8194a993d0993e2e0767f"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28ee4d893f01351852cfbf7aed758d1e81d19e48bf52e171aaef748448e9cc92"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1b9698a8a891f98bd6470def5afe98e7a6d0711c0d7cd27f1ab0534120731d3"
    sha256 cellar: :any_skip_relocation, catalina:      "39c8c255944b98e4829d355f5555f6bc3480819ccce420d90bc8696294fd07d6"
    sha256 cellar: :any_skip_relocation, mojave:        "264992037829d5853e7cc9c7ce6b9b09d2e019850f60bc257df8de13615558af"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
