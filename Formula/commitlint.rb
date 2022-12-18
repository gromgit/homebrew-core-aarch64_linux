require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.3.0.tgz"
  sha256 "37ebb051e3600e731fc3be3cf3b84b4fa88d8003d8b8c99dffa7dc4ea927c37e"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/commitlint"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f65b05c65c41d73c78f28003cdf6684cafaf111954f749f0f6aa9b2d34741b84"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output("#{bin}/commitlint", "foo: message")
  end
end
