require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.33.1.tgz"
  sha256 "d88d7bfebd0562c2b6bd92d31b9278a2fb059adb150531bc82fa7f92ee07085f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4576cd8c040191af0c47d70782d37aec062b862de4b276a35f9e094993852b21"
    sha256 cellar: :any_skip_relocation, big_sur:       "032a7dc4cc7e7236f8d82daf7731e671c6a1469806ddadbfed635e14b542436a"
    sha256 cellar: :any_skip_relocation, catalina:      "032a7dc4cc7e7236f8d82daf7731e671c6a1469806ddadbfed635e14b542436a"
    sha256 cellar: :any_skip_relocation, mojave:        "032a7dc4cc7e7236f8d82daf7731e671c6a1469806ddadbfed635e14b542436a"
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
