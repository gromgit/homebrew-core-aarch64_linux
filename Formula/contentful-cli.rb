require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.14.0.tgz"
  sha256 "ee35d4a1ed61f3fedf381b49a5689dff1b4ce015b9201cbd74a54154ee7489cd"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d94aa180469868e4982e7cb35cec174960781b23ab7168c816997d68d5d8544"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d94aa180469868e4982e7cb35cec174960781b23ab7168c816997d68d5d8544"
    sha256 cellar: :any_skip_relocation, monterey:       "fb7c88b65e720346b50a2808034b647f94de916f397a11465e45d260786a2f32"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb7c88b65e720346b50a2808034b647f94de916f397a11465e45d260786a2f32"
    sha256 cellar: :any_skip_relocation, catalina:       "fb7c88b65e720346b50a2808034b647f94de916f397a11465e45d260786a2f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d94aa180469868e4982e7cb35cec174960781b23ab7168c816997d68d5d8544"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
