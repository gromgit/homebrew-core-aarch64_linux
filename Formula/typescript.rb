require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.3.3.tgz"
  sha256 "92a6f508086a76537153b48c12cc4980a32ed9d4357b6dce90ceb2e035a05442"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94b3f0c6c97615f6fc1c727251ace6ee707d1e3c9875485bf3a7b38b09570ead"
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
