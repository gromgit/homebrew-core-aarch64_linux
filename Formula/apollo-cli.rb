require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.32.11.tgz"
  sha256 "5605644dfe12bec6deedc235698c0d1c2cb505dca6873f19956cb90c78a51197"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "154c6fc5bcdb5dd2fb52fab347569be7f9a99b454f165c6caac152a103f75db3"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1dcc1ce0f28abc3f74c55d6f7d8e13c3c621efc68dad509d3001237e81d322c"
    sha256 cellar: :any_skip_relocation, catalina:      "b1dcc1ce0f28abc3f74c55d6f7d8e13c3c621efc68dad509d3001237e81d322c"
    sha256 cellar: :any_skip_relocation, mojave:        "b1dcc1ce0f28abc3f74c55d6f7d8e13c3c621efc68dad509d3001237e81d322c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Error: No schema provider was created", error_output
  end
end
