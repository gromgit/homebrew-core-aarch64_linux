require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.8.0.tgz"
  sha256 "9db78ebac41b19501af6f5e2c4c8bb452006b8337b385031563d63764933fb1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a93eea33f01d5c965353d97a25fb02db85a15ebf766adba02927716b2214d785" => :catalina
    sha256 "a491327930efab8def7ef4e365cb20bf3fc9ae45fd17b60a9068fc1a8b23a7e0" => :mojave
    sha256 "1b84be5a330c39580f3e753fa2cfb6164a0c11e500df88c2237b35d6b18f40fb" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
