require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.32.13.tgz"
  sha256 "291c0eda01b27575f993b7f8b7ca14058b86d500c1974f02689e02073f024ec1"
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
