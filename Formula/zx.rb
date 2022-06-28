require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.3.tgz"
  sha256 "178acd31fc607ad98d27f6b0386163f8601f32235161a316f72a2cf6c55d70ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c108e5d3ddef4300fad67be56f61f5fe7389e2d6439bd83cd677c49d4d8527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71c108e5d3ddef4300fad67be56f61f5fe7389e2d6439bd83cd677c49d4d8527"
    sha256 cellar: :any_skip_relocation, monterey:       "e7ba69208a2c46a872c2ddd09d0ad515dc41377f3e494bf00588d7d668a8543e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7ba69208a2c46a872c2ddd09d0ad515dc41377f3e494bf00588d7d668a8543e"
    sha256 cellar: :any_skip_relocation, catalina:       "e7ba69208a2c46a872c2ddd09d0ad515dc41377f3e494bf00588d7d668a8543e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c108e5d3ddef4300fad67be56f61f5fe7389e2d6439bd83cd677c49d4d8527"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~EOS
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath/"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
